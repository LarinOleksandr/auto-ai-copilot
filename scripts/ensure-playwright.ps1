Param(
  [string]$Version = "latest",
  [ValidateSet("chromium", "firefox", "webkit", "all")]
  [string]$Browser = "chromium"
)

$ErrorActionPreference = "Stop"

function Require-Command([string]$Name) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Missing required command: $Name"
  }
}

function Assert-LastExitCode([string]$What) {
  if ($LASTEXITCODE -ne 0) {
    throw "$What failed (exit code: $LASTEXITCODE)."
  }
}

Require-Command "node"
Require-Command "npm"

Write-Host "Ensuring Playwright is available (on-demand via npm exec)."
Write-Host "Playwright version: $Version"

npm exec -y "@playwright/test@$Version" -- --version | ForEach-Object { Write-Host $_ }
Assert-LastExitCode "Playwright version check"

if ($Browser -eq "all") {
  Write-Host "Installing Playwright browsers: chromium, firefox, webkit"
  npm exec -y "@playwright/test@$Version" -- install chromium firefox webkit
  Assert-LastExitCode "Playwright browser install"
} else {
  Write-Host "Installing Playwright browser: $Browser"
  npm exec -y "@playwright/test@$Version" -- install $Browser
  Assert-LastExitCode "Playwright browser install"
}

Write-Host "Done."
