param(
  [Parameter(Mandatory = $true)][string]$HeadBranch,
  [string]$BaseBranch,
  [ValidateSet("merge", "squash", "rebase")][string]$MergeMethod = "merge",
  [switch]$DeleteBranch,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-GitOutput {
  param([Parameter(Mandatory = $true)][string[]]$Args)
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required but was not found on PATH."
  }
  $out = & git @Args
  if ($LASTEXITCODE -ne 0) {
    throw ("git " + ($Args -join " ") + " failed with exit code " + $LASTEXITCODE)
  }
  return ($out | Out-String).Trim()
}

function Resolve-BaseBranch {
  param([string]$Candidate)
  if (-not [string]::IsNullOrWhiteSpace($Candidate)) { return $Candidate }

  $branches = Get-GitOutput @("branch", "--format=%(refname:short)")
  $list = @()
  if (-not [string]::IsNullOrWhiteSpace($branches)) {
    $list = $branches -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
  }
  if ($list -contains "main") { return "main" }
  if ($list -contains "master") { return "master" }
  return "main"
}

function Get-OriginOwnerRepo {
  param([Parameter(Mandatory = $true)][string]$RemoteUrl)

  $url = $RemoteUrl.Trim()
  $owner = $null
  $repo = $null

  if ($url -match "^git@github\\.com:(?<owner>[^/]+)/(?<repo>[^/]+?)(\\.git)?$") {
    $owner = $Matches["owner"]
    $repo = $Matches["repo"]
  } elseif ($url -match "^https?://github\\.com/(?<owner>[^/]+)/(?<repo>[^/]+?)(\\.git)?/?$") {
    $owner = $Matches["owner"]
    $repo = $Matches["repo"]
  }

  if ([string]::IsNullOrWhiteSpace($owner) -or [string]::IsNullOrWhiteSpace($repo)) {
    throw ("Unable to parse GitHub owner/repo from origin: " + $RemoteUrl)
  }

  return @($owner, $repo)
}

function Import-DotEnv {
  param([Parameter(Mandatory = $true)][string]$Path)

  if (-not (Test-Path $Path)) { return }

  $lines = Get-Content -Path $Path -ErrorAction Stop
  foreach ($line in $lines) {
    $raw = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($raw)) { continue }
    if ($raw.StartsWith("#")) { continue }

    $idx = $raw.IndexOf("=")
    if ($idx -le 0) { continue }

    $name = $raw.Substring(0, $idx).Trim()
    $value = $raw.Substring($idx + 1)

    if ([string]::IsNullOrWhiteSpace($name)) { continue }
    if (-not [string]::IsNullOrWhiteSpace((Get-Item ("Env:" + $name) -ErrorAction SilentlyContinue).Value)) { continue }

    Set-Item -Path ("Env:" + $name) -Value $value | Out-Null
  }
}

function Invoke-GitHubApi {
  param(
    [Parameter(Mandatory = $true)][string]$Method,
    [Parameter(Mandatory = $true)][string]$Url,
    [Parameter(Mandatory = $false)]$Body
  )

  $token = $env:GITHUB_TOKEN
  if ([string]::IsNullOrWhiteSpace($token)) { $token = $env:GH_TOKEN }
  if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Missing env var GITHUB_TOKEN (or GH_TOKEN)."
  }

  $headers = @{
    "Authorization" = ("Bearer " + $token)
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
    "User-Agent" = "auto-ai-copilot"
  }

  if ($null -eq $Body) {
    return Invoke-RestMethod -Method $Method -Uri $Url -Headers $headers
  }

  $json = $Body | ConvertTo-Json -Depth 10
  return Invoke-RestMethod -Method $Method -Uri $Url -Headers $headers -ContentType "application/json" -Body $json
}

$repoRoot = Get-GitOutput @("rev-parse", "--show-toplevel")
Push-Location $repoRoot
try {
  Import-DotEnv -Path (Join-Path $repoRoot ".env")

  $base = Resolve-BaseBranch -Candidate $BaseBranch

  $remote = Get-GitOutput @("remote", "get-url", "origin")
  $owner, $repo = Get-OriginOwnerRepo -RemoteUrl $remote

  $apiBase = ("https://api.github.com/repos/" + $owner + "/" + $repo)
  $head = ($owner + ":" + $HeadBranch)

  $prs = Invoke-GitHubApi -Method "GET" -Url ($apiBase + "/pulls?state=open&head=" + $head + "&base=" + $base + "&per_page=1")
  if (-not $prs -or $prs.Count -lt 1) {
    throw ("No open PR found for head '" + $head + "' into base '" + $base + "'.")
  }

  $pr = $prs[0]
  Write-Host ("PR: " + $pr.html_url)

  if ($DryRun) { exit 0 }

  $merge = Invoke-GitHubApi -Method "PUT" -Url ($apiBase + "/pulls/" + $pr.number + "/merge") -Body @{
    merge_method = $MergeMethod
  }
  if (-not $merge.merged) {
    throw "GitHub API did not report merged=true."
  }

  Write-Host ("Merged via " + $MergeMethod + ".")

  if ($DeleteBranch) {
    try {
      Invoke-GitHubApi -Method "DELETE" -Url ($apiBase + "/git/refs/heads/" + $HeadBranch) | Out-Null
      Write-Host "Deleted branch on remote."
    } catch {
      Write-Host "Unable to delete branch on remote; continuing."
    }
  }
} finally {
  Pop-Location
}

