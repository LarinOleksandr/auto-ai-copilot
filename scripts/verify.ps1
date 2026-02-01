param(
  [switch]$Verbose
)

$ErrorActionPreference = "Stop"

function Get-GitFiles {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required but was not found on PATH."
  }

  $out = & git ls-files
  if ($LASTEXITCODE -ne 0) { throw "git ls-files failed." }
  return ($out | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function Get-TargetFiles {
  $files = Get-GitFiles

  return $files | Where-Object {
    ($_ -eq "AGENTS.md") -or
    ($_ -like ".codex/skills/*") -or
    ($_ -like "docs/*") -or
    ($_ -like "docs-ai/*")
  } | Where-Object {
    $_.ToLowerInvariant().EndsWith(".md") -or $_.ToLowerInvariant().EndsWith(".ps1")
  }
}

function Find-AbsolutePaths {
  param([Parameter(Mandatory = $true)][string[]]$Files)

  $patterns = @(
    # Windows drive absolute paths
    "(?i)\b[A-Z]:\\",
    "(?i)\b[A-Z]:/",
    # Common OS user home absolutes
    "/Users/",
    "/home/"
  )

  $hits = @()
  foreach ($file in $Files) {
    if (-not (Test-Path $file)) { continue }

    foreach ($pattern in $patterns) {
      $matches = Select-String -Path $file -Pattern $pattern -AllMatches -SimpleMatch:$false -Encoding UTF8 -ErrorAction SilentlyContinue
      foreach ($m in $matches) {
        $hits += [pscustomobject]@{
          File = $file
          Line = $m.LineNumber
          Text = $m.Line.Trim()
          Pattern = $pattern
        }
      }
    }
  }

  return $hits
}

$targets = Get-TargetFiles
if ($Verbose) {
  Write-Host ("Verifying " + $targets.Count + " tracked files...")
}

$hits = Find-AbsolutePaths -Files $targets

if ($hits.Count -gt 0) {
  Write-Host "Verification failed: absolute OS paths found. Use KB_ROOTS aliases (ROOT_*/KB_*/DOC_*) or repo-relative paths."
  Write-Host ""
  $hits | Sort-Object File, Line | Select-Object -First 200 | ForEach-Object {
    Write-Host ("- " + $_.File + ":" + $_.Line + " :: " + $_.Text)
  }
  if ($hits.Count -gt 200) {
    Write-Host ("... plus " + ($hits.Count - 200) + " more.")
  }
  exit 1
}

Write-Host "Verification passed."

