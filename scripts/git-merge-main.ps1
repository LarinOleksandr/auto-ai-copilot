param(
  [string]$BaseBranch,
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
  $workBranch = Get-GitOutput @("rev-parse", "--abbrev-ref", "HEAD")

  if ($workBranch -eq $base) {
    throw "Refusing to merge '$base' into itself. Switch to a work branch first."
  }

  $status = Get-GitOutput @("status", "--porcelain")
  if (-not [string]::IsNullOrWhiteSpace($status)) {
    throw "Working tree is not clean. Commit or stash changes before merging."
  }

  Write-Host ("Base: " + $base)
  Write-Host ("Work: " + $workBranch)

  if ($DryRun) { exit 0 }

  # Ensure base is up to date.
  Invoke-Git @("checkout", $base)

  # If origin exists, pull latest base.
  $hasOrigin = $true
  try {
    [void](Get-GitOutput @("remote", "get-url", "origin"))
  } catch {
    $hasOrigin = $false
  }

  if ($hasOrigin) {
    # Keep base up to date when possible, but don't fail if the remote base branch doesn't exist yet.
    Invoke-Git @("fetch", "origin", "--prune")

    & git show-ref --verify --quiet ("refs/remotes/origin/" + $base)
    $remoteBaseExists = ($LASTEXITCODE -eq 0)

    if ($remoteBaseExists) {
      try {
        Invoke-Git @("merge", "--ff-only", ("origin/" + $base))
      } catch {
        throw "Cannot fast-forward '$base' from origin. Resolve base branch updates manually before merging."
      }
    } else {
      Write-Host ("Remote branch 'origin/" + $base + "' not found; skipping base update.")
    }
  }

  # Merge work into base.
  Invoke-Git @("merge", $workBranch)

  if ($hasOrigin) {
    Invoke-Git @("push", "origin", $base)
  }

  Write-Host "Merged successfully."
} finally {
  Pop-Location
}
