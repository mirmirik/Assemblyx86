param([switch]$clean)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $root "src\main.asm"
$buildDir = Join-Path $root "build"
if (!(Test-Path $buildDir)) { New-Item -ItemType Directory -Path $buildDir | Out-Null }

if ($clean) {
    Remove-Item (Join-Path $buildDir '*') -Force -Recurse -ErrorAction SilentlyContinue
    Write-Output "Cleaned $buildDir"
    exit 0
}

if (-not (Get-Command nasm -ErrorAction SilentlyContinue)) {
    Write-Error "nasm not found. Install NASM (https://www.nasm.us/) and ensure it's on PATH."
    exit 1
}

if ($IsWindows) {
    $obj = Join-Path $buildDir "main.obj"
    $exe = Join-Path $buildDir "main.exe"
    & nasm -f win32 $src -o $obj
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    if (Get-Command gcc -ErrorAction SilentlyContinue) {
        & gcc $obj -o $exe
        Write-Output "Built $exe"
    } elseif (Get-Command ld -ErrorAction SilentlyContinue) {
        & ld -o $exe $obj
        Write-Output "Built $exe"
    } else {
        Write-Output "Assembled object at $obj. Link with mingw-w64 gcc or other linker to produce an executable."
    }
} else {
    $obj = Join-Path $buildDir "main.o"
    $bin = Join-Path $buildDir "main"
    & nasm -f elf32 $src -o $obj
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    if (Get-Command ld -ErrorAction SilentlyContinue) {
        & ld -m elf_i386 $obj -o $bin
        Write-Output "Built $bin"
    } elseif (Get-Command gcc -ErrorAction SilentlyContinue) {
        & gcc -m32 $obj -o $bin
        Write-Output "Built $bin"
    } else {
        Write-Output "Assembled object at $obj. Link with gcc/ld to produce an executable."
    }
}
