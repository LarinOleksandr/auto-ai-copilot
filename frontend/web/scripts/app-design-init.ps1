param(
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-QueryParam {
  param(
    [Parameter(Mandatory = $true)][string]$Url,
    [Parameter(Mandatory = $true)][string]$Key
  )

  try {
    $uri = [System.Uri]::new($Url)
  } catch {
    return $null
  }

  $query = $uri.Query
  if ([string]::IsNullOrWhiteSpace($query)) { return $null }
  $query = $query.TrimStart('?')
  foreach ($pair in ($query -split '&')) {
    if ([string]::IsNullOrWhiteSpace($pair)) { continue }
    $kv = $pair -split '=', 2
    $k = [System.Uri]::UnescapeDataString($kv[0])
    if ($k -ne $Key) { continue }
    if ($kv.Length -lt 2) { return "" }
    return [System.Uri]::UnescapeDataString($kv[1])
  }

  return $null
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$webRoot = Resolve-Path (Join-Path $scriptDir "..")
$configPath = Join-Path $webRoot "config\\app-design-preset.json"
$approvalPath = Join-Path $webRoot "config\\deps-approved.json"

if (-not (Test-Path $configPath)) {
  throw "Missing config: $configPath"
}

if (-not (Test-Path $approvalPath)) {
  throw "Missing dependency approval marker: $approvalPath`nAgent must obtain explicit approval (KB_REPOSITORY_RULES) and then create this file."
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$presetUrl = $config.presetUrl

if ([string]::IsNullOrWhiteSpace($presetUrl)) { throw "config.presetUrl is required in $configPath" }

$templateFromUrl = Get-QueryParam -Url $presetUrl -Key "template"
$templateFromConfig = $config.template

if (-not [string]::IsNullOrWhiteSpace($templateFromConfig) -and -not [string]::IsNullOrWhiteSpace($templateFromUrl) -and ($templateFromConfig -ne $templateFromUrl)) {
  throw "Template mismatch. config.template is '$templateFromConfig' but presetUrl contains template='$templateFromUrl'. Update frontend/web/config/app-design-preset.json so they match."
}

$template = $templateFromConfig
if ([string]::IsNullOrWhiteSpace($template)) { $template = $templateFromUrl }
if ([string]::IsNullOrWhiteSpace($template)) { throw "Template is required. Set config.template in $configPath or ensure presetUrl includes ?template=..." }

if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  throw "pnpm is required but was not found on PATH."
}

$argsList = @(
  "dlx",
  "shadcn@latest",
  "create",
  "--preset",
  $presetUrl,
  "--template",
  $template
)

Write-Host ("Resolved template: " + $template)
Write-Host "Applying design preset in $webRoot"
Write-Host ("Command: pnpm " + ($argsList -join " "))

if ($DryRun) { exit 0 }

Push-Location $webRoot
try {
  & pnpm @argsList
} finally {
  Pop-Location
}
