param(
  [Parameter(Mandatory = $true)][string]$ThreadName,
  [string]$BaseBranch,
  [switch]$NoPull,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
  param([Parameter(Mandatory = $true)][string]$PathLike)
  try {
    return [System.IO.Path]::GetFullPath($PathLike)
  } catch {
    throw "Invalid path: $PathLike"
  }
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

function Resolve-AnchorRoot {
  $worktreeRoot = $null
  try {
    $worktreeRoot = Get-GitOutput @("rev-parse", "--show-toplevel")
  } catch {
    throw "This script must be run inside a git repository."
  }

  $commonDir = $null
  try {
    $commonDir = Get-GitOutput @("rev-parse", "--git-common-dir")
  } catch {
    return $worktreeRoot
  }

  $worktreeRootFull = Resolve-FullPath $worktreeRoot
  $commonDirFull = $commonDir
  if (-not [System.IO.Path]::IsPathRooted($commonDirFull)) {
    $commonDirFull = Resolve-FullPath (Join-Path $worktreeRootFull $commonDirFull)
  } else {
    $commonDirFull = Resolve-FullPath $commonDirFull
  }

  if ($commonDirFull.ToLowerInvariant().EndsWith("\.git") -or $commonDirFull.ToLowerInvariant().EndsWith("/.git")) {
    return (Split-Path $commonDirFull -Parent)
  }

  return $worktreeRoot
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

function Slugify {
  param([Parameter(Mandatory = $true)][string]$Text)

  $t = $Text.ToLowerInvariant()
  $t = $t -replace "[^a-z0-9]+", "-"
  $t = $t -replace "-{2,}", "-"
  $t = $t.Trim("-")
  if ([string]::IsNullOrWhiteSpace($t)) { return "work" }
  if ($t.Length -gt 60) { return $t.Substring(0, 60).Trim("-") }
  return $t
}

function Parse-ThreadName {
  param([Parameter(Mandatory = $true)][string]$Name)

  $n = $Name.Trim()
  $code = $null
  $goal = $null

  $m = [regex]::Match($n, "\|\s*(?<code>[A-Z]{1,3}-\d+)\s*:\s*(?<goal>.+)$")
  if ($m.Success) {
    $code = $m.Groups["code"].Value.Trim()
    $goal = $m.Groups["goal"].Value.Trim()
  } else {
    $m2 = [regex]::Match($n, "\|\s*(?<goal>.+)$")
    if ($m2.Success) {
      $goal = $m2.Groups["goal"].Value.Trim()
    } else {
      $goal = $n
    }
  }

  return [pscustomobject]@{
    Code = $code
    Goal = $goal
  }
}

function Map-CodeToBranchPrefix {
  param([string]$Code)

  if ([string]::IsNullOrWhiteSpace($Code)) { return "chore" }
  $prefix = ($Code.Split("-", 2)[0]).ToUpperInvariant()
  switch ($prefix) {
    "F" { return "feature" }
    "B" { return "bugfix" }
    "RF" { return "refactor" }
    "D" { return "docs" }
    "DP" { return "deploy" }
    "A" { return "architecture" }
    "E" { return "experiment" }
    "CR" { return "review" }
    "DR" { return "design" }
    default { return "chore" }
  }
}

function Ensure-UniqueBranchName {
  param([Parameter(Mandatory = $true)][string]$BranchName)

  $branches = Get-GitOutput @("branch", "--format=%(refname:short)")
  $set = @{}
  if (-not [string]::IsNullOrWhiteSpace($branches)) {
    foreach ($b in ($branches -split "`n")) {
      $bn = $b.Trim()
      if ([string]::IsNullOrWhiteSpace($bn)) { continue }
      $set[$bn] = $true
    }
  }

  if (-not $set.ContainsKey($BranchName)) { return $BranchName }

  $i = 2
  while ($true) {
    $candidate = "$BranchName-$i"
    if (-not $set.ContainsKey($candidate)) { return $candidate }
    $i++
    if ($i -gt 99) { throw "Could not find an available branch name based on '$BranchName'." }
  }
}

$anchorRoot = Resolve-AnchorRoot

Push-Location $anchorRoot
try {
  $base = Resolve-BaseBranch -Candidate $BaseBranch
  $parsed = Parse-ThreadName -Name $ThreadName
  $branchPrefix = Map-CodeToBranchPrefix -Code $parsed.Code

  $codeSlug = $null
  if (-not [string]::IsNullOrWhiteSpace($parsed.Code)) { $codeSlug = $parsed.Code.ToLowerInvariant() }
  $goalSlug = Slugify -Text $parsed.Goal

  $tail = $goalSlug
  if (-not [string]::IsNullOrWhiteSpace($codeSlug)) { $tail = "$codeSlug-$goalSlug" }

  $branchName = Ensure-UniqueBranchName -BranchName ("$branchPrefix/$tail")
  $worktreePath = Join-Path ".worktrees" $branchName

  $anchorRootFull = Resolve-FullPath $anchorRoot

  Write-Host ("Base branch: " + $base)
  Write-Host ("Target branch: " + $branchName)
  Write-Host ("Worktree path: " + (Join-Path $anchorRootFull $worktreePath))

  $ignored = $false
  & git check-ignore -q ".worktrees/" | Out-Null
  if ($LASTEXITCODE -eq 0) { $ignored = $true }
  if (-not $ignored) {
    & git check-ignore -q ".worktrees" | Out-Null
    if ($LASTEXITCODE -eq 0) { $ignored = $true }
  }
  if (-not $ignored) {
    throw "'.worktrees/' is not ignored by git. Add '.worktrees/' to .gitignore before creating worktrees."
  }

  if ($DryRun) { exit 0 }

  if (-not $NoPull) {
    $hasOrigin = $true
    try {
      [void](Get-GitOutput @("remote", "get-url", "origin"))
    } catch {
      $hasOrigin = $false
    }

    if ($hasOrigin) {
      Invoke-Git @("fetch", "origin", "--prune")
      & git show-ref --verify --quiet ("refs/remotes/origin/" + $base)
      $remoteBaseExists = ($LASTEXITCODE -eq 0)
      if ($remoteBaseExists) {
        try {
          Invoke-Git @("fetch", "origin", $base)
        } catch {
          Write-Host ("Unable to fetch origin/" + $base + "; continuing.")
        }
      }
    }
  }

  New-Item -ItemType Directory -Force -Path (Split-Path $worktreePath -Parent) | Out-Null
  Invoke-Git @("worktree", "add", "-b", $branchName, $worktreePath, $base)

  Write-Host "Worktree created."
  Write-Host ("Next: cd " + (Join-Path $anchorRootFull $worktreePath))
} finally {
  Pop-Location
}
