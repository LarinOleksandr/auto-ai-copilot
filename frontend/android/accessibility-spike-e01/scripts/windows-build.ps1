param()

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $projectRoot

$studioRoot = "C:\\Program Files\\Android\\Android Studio"
$java = Join-Path $studioRoot "jbr\\bin\\java.exe"
if (!(Test-Path $java)) {
  throw "Android Studio JDK not found at: $java"
}

$sdkRoot = Join-Path $env:LOCALAPPDATA "Android\\Sdk"
if (!(Test-Path $sdkRoot)) {
  throw "Android SDK not found. Open Android Studio once and finish the first-time setup wizard."
}

$localProps = Join-Path $projectRoot "local.properties"
@"
sdk.dir=$($sdkRoot -replace '\\','\\\\')
"@ | Set-Content -Path $localProps -Encoding ASCII

Push-Location $projectRoot
try {
  $env:JAVA_HOME = (Split-Path -Parent (Split-Path -Parent $java))
  .\\gradlew.bat assembleDebug
} finally {
  Pop-Location
}

