$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$exeWin = Join-Path $root "build\main.exe"
$exeUnix = Join-Path $root "build/main"

if (Test-Path $exeWin) { & $exeWin; exit $LASTEXITCODE }
if (Test-Path $exeUnix) { & $exeUnix; exit $LASTEXITCODE }

Write-Error "No executable found in build/. Run build.ps1 first."