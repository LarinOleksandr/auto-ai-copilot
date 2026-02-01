param(
  [string]$BaseBranch,
  [switch]$SkipGh,
  [switch]$SkipApi,
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

function Invoke-Git {
  param([Parameter(Mandatory = $true)][string[]]$Args)
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required but was not found on PATH."
  }
  & git @Args
  if ($LASTEXITCODE -ne 0) {
    throw ("git " + ($Args -join " ") + " failed with exit code " + $LASTEXITCODE)
  }
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

  # Supports:
  # - https://github.com/<owner>/<repo>.git
  # - https://github.com/<owner>/<repo>
  # - git@github.com:<owner>/<repo>.git
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

function Invoke-GitHubApi {
  param(
    [Parameter(Mandatory = $true)][string]$Method,
    [Parameter(Mandatory = $true)][string]$Url,
    [Parameter(Mandatory = $false)]$Body
  )

  $token = $env:GITHUB_TOKEN
  if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Missing env var GITHUB_TOKEN."
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

$repoRoot = $null
try {
  $repoRoot = Get-GitOutput @("rev-parse", "--show-toplevel")
} catch {
  throw "This script must be run inside a git repository."
}

Push-Location $repoRoot
try {
  $base = Resolve-BaseBranch -Candidate $BaseBranch
  $branch = Get-GitOutput @("rev-parse", "--abbrev-ref", "HEAD")
  if ($branch -eq $base) {
    throw "Refusing to create a PR from '$base'. Switch to a work branch first."
  }

  $remote = $null
  try {
    $remote = Get-GitOutput @("remote", "get-url", "origin")
  } catch {
    throw "Missing remote 'origin'. Add a remote before pushing/creating PR."
  }

  $title = Get-GitOutput @("log", "-1", "--pretty=%s")

  Write-Host ("Remote: " + $remote)
  Write-Host ("Base: " + $base)
  Write-Host ("Head: " + $branch)
  Write-Host ("Title: " + $title)

  if ($DryRun) { exit 0 }

  Invoke-Git @("push", "-u", "origin", $branch)

  if ($SkipGh) {
    Write-Host "Skipping GitHub PR creation (SkipGh enabled)."
    Write-Host ("Next: open a PR into '" + $base + "' from branch '" + $branch + "'.")
    exit 0
  }

  $gh = Get-Command gh -ErrorAction SilentlyContinue
  if (-not $gh) {
    if ($SkipApi) {
      Write-Host "GitHub CLI (gh) not found; pushed branch only (SkipApi enabled)."
      Write-Host ("Next: open a PR into '" + $base + "' from branch '" + $branch + "'.")
      exit 0
    }

    $token = $env:GITHUB_TOKEN
    if ([string]::IsNullOrWhiteSpace($token)) {
      Write-Host "GitHub CLI (gh) not found and GITHUB_TOKEN is not set; pushed branch only."
      Write-Host ("Next: open a PR into '" + $base + "' from branch '" + $branch + "'.")
      exit 0
    }

    $owner, $repo = Get-OriginOwnerRepo -RemoteUrl $remote
    $apiBase = ("https://api.github.com/repos/" + $owner + "/" + $repo)

    try {
      $pr = Invoke-GitHubApi -Method "POST" -Url ($apiBase + "/pulls") -Body @{
        title = $title
        head  = $branch
        base  = $base
        body  = "Created by Codex agent."
      }

      Write-Host ("PR created: " + $pr.html_url)
      exit 0
    } catch {
      # If PR already exists, try to find it.
      try {
        $prs = Invoke-GitHubApi -Method "GET" -Url ($apiBase + "/pulls?state=open&head=" + $owner + ":" + $branch + "&base=" + $base + "&per_page=1")
        if ($prs -and $prs.Count -ge 1 -and $prs[0].html_url) {
          Write-Host ("PR already exists: " + $prs[0].html_url)
          exit 0
        }
      } catch {
        # ignore lookup errors
      }

      Write-Host "Unable to create PR via GitHub API; pushed branch only."
      Write-Host ("Next: open a PR into '" + $base + "' from branch '" + $branch + "'.")
      exit 0
    }
  }

  try {
    & gh pr create --base $base --head $branch --title $title --body "Created by Codex agent." | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "gh pr create failed." }
  } catch {
    Write-Host "Unable to create PR automatically via gh."
    Write-Host ("You can run: gh pr create --base " + $base + " --head " + $branch + " --fill")
  }
} finally {
  Pop-Location
}
