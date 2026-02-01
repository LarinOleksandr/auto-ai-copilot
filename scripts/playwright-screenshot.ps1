Param(
  [Parameter(Mandatory = $true)]
  [string]$Url,

  [Parameter(Mandatory = $true)]
  [string]$OutFile,

  [string]$Version = "latest",

  [ValidateSet("chromium", "firefox", "webkit")]
  [string]$Browser = "chromium"
)

$ErrorActionPreference = "Stop"

$ensureScript = Join-Path $PSScriptRoot "ensure-playwright.ps1"
& $ensureScript -Version $Version -Browser $Browser

Write-Host "Capturing screenshot:"
Write-Host "  URL: $Url"
Write-Host "  File: $OutFile"

$outDir = Split-Path -Parent $OutFile
if ($outDir -and -not (Test-Path $outDir)) {
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

npm exec -y "@playwright/test@$Version" -- screenshot --browser $Browser $Url $OutFile
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Done."
