param(
  [string]$BaseBranch,
  [switch]$SkipGh,
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
    Write-Host "GitHub CLI (gh) not found; pushed branch only."
    Write-Host ("Next: open a PR into '" + $base + "' from branch '" + $branch + "'.")
    exit 0
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
