param(
  [Parameter(Mandatory = $true)][string]$ThreadName,
  [switch]$NoPull,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

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

function Get-BaseBranch {
  $branches = Get-GitOutput @("branch", "--format=%(refname:short)")
  $list = @()
  if (-not [string]::IsNullOrWhiteSpace($branches)) {
    $list = $branches -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
  }
  if ($list -contains "main") { return "main" }
  if ($list -contains "master") { return "master" }
  return $null
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

$repoRoot = $null
try {
  $repoRoot = Get-GitOutput @("rev-parse", "--show-toplevel")
} catch {
  throw "This script must be run inside a git repository."
}

Push-Location $repoRoot
try {
  $parsed = Parse-ThreadName -Name $ThreadName
  $branchPrefix = Map-CodeToBranchPrefix -Code $parsed.Code

  $codeSlug = $null
  if (-not [string]::IsNullOrWhiteSpace($parsed.Code)) { $codeSlug = $parsed.Code.ToLowerInvariant() }
  $goalSlug = Slugify -Text $parsed.Goal

  $tail = $goalSlug
  if (-not [string]::IsNullOrWhiteSpace($codeSlug)) { $tail = "$codeSlug-$goalSlug" }

  $branchName = Ensure-UniqueBranchName -BranchName ("$branchPrefix/$tail")

  $base = Get-BaseBranch
  $current = Get-GitOutput @("rev-parse", "--abbrev-ref", "HEAD")
  $dirty = -not [string]::IsNullOrWhiteSpace((Get-GitOutput @("status", "--porcelain")))

  Write-Host ("Current branch: " + $current)
  if ($base) { Write-Host ("Base branch: " + $base) }
  Write-Host ("Target branch: " + $branchName)

  if ($DryRun) { exit 0 }

  if ($current -ne $base -and -not $dirty -and $base) {
    Invoke-Git @("checkout", $base)
    if (-not $NoPull) {
      try {
        $null = Get-GitOutput @("remote", "get-url", "origin")
        Invoke-Git @("pull", "--ff-only")
      } catch {
        Write-Host "Skipping pull (no remote 'origin' or pull failed)."
      }
    }
  }

  if ($dirty -and $current -ne $base) {
    Write-Host "Working tree is not clean; creating branch from current HEAD (rebase onto base later if needed)."
  }

  Invoke-Git @("checkout", "-b", $branchName)
  Write-Host ("Switched to branch: " + $branchName)
} finally {
  Pop-Location
}
