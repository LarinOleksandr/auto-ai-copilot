param()

$ErrorActionPreference = "Stop"

function Write-Section($title) {
  Write-Host ""
  Write-Host ("=== " + $title + " ===")
}

Write-Section "Android Studio"
$studioRoot = "C:\\Program Files\\Android\\Android Studio"
$studioExe = Join-Path $studioRoot "bin\\studio64.exe"
$studioJbrJava = Join-Path $studioRoot "jbr\\bin\\java.exe"

if (Test-Path $studioExe) {
  Write-Host "OK: Android Studio found:"
  Write-Host ("  " + $studioExe)
} else {
  Write-Host "MISSING: Android Studio not found at the default path:"
  Write-Host ("  " + $studioExe)
}

if (Test-Path $studioJbrJava) {
  Write-Host "OK: Android Studio JDK (java.exe) found:"
  Write-Host ("  " + $studioJbrJava)
} else {
  Write-Host "MISSING: Android Studio JDK (java.exe) not found:"
  Write-Host ("  " + $studioJbrJava)
}

Write-Section "Android SDK"
$sdkRoot = Join-Path $env:LOCALAPPDATA "Android\\Sdk"
Write-Host ("Expected SDK folder: " + $sdkRoot)

if (!(Test-Path $sdkRoot)) {
  Write-Host "MISSING: Android SDK folder does not exist yet."
  Write-Host "Next: open Android Studio once and complete the first-time setup wizard (Standard install)."
  exit 0
}

$sdkManagerBat = Join-Path $sdkRoot "cmdline-tools\\latest\\bin\\sdkmanager.bat"
$emulatorExe = Join-Path $sdkRoot "emulator\\emulator.exe"
$adbExe = Join-Path $sdkRoot "platform-tools\\adb.exe"

foreach ($p in @($sdkManagerBat, $emulatorExe, $adbExe)) {
  if (Test-Path $p) {
    Write-Host ("OK: " + $p)
  } else {
    Write-Host ("MISSING: " + $p)
  }
}

Write-Section "Android SDK Packages (common)"
$need = @(
  (Join-Path $sdkRoot "platforms\\android-34"),
  (Join-Path $sdkRoot "build-tools\\34.0.0")
)
foreach ($p in $need) {
  if (Test-Path $p) {
    Write-Host ("OK: " + $p)
  } else {
    Write-Host ("MISSING: " + $p)
  }
}

