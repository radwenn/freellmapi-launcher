# FreeLLMAPI Launcher - Setup script
#
# This script clones the FreeLLMAPI project at a pinned commit, copies the
# launcher files into <installation>\launcher\, and runs `npm run dev` to
# start the local proxy.
#
# $FreeLLMAPIRef is the pinned commit hash (full 40-char SHA-1). Update it
# when the upstream project moves to a new version you want to ship.
#   git -C <your-freellmapi-dir> rev-parse HEAD
# Then replace the value below with the new hash.
param(
    [string]$Ref,
    [switch]$DryRun,
    [string]$Target = "$env:LOCALAPPDATA\freellmapi",
    [string]$SourceDir = $PSScriptRoot
)

$FreeLLMAPIRef = "9d2b4b407b12e489ecd35320cd630d5ff97cd666"
if (-not [string]::IsNullOrWhiteSpace($Ref)) {
    $FreeLLMAPIRef = $Ref.Trim()
}

$launcherFiles = @("start.bat", "stop.bat", "launcher.ps1", "make-icon.ps1", "make-shortcut.ps1")
$launcherDest = Join-Path $Target "launcher"

if ($DryRun) {
    Write-Host "DryRun: FreeLLMAPIRef = $FreeLLMAPIRef"
    Write-Host "DryRun: Target directory = $Target"
    Write-Host "DryRun: Launcher destination = $launcherDest"
    Write-Host "DryRun: Files to copy = $($launcherFiles -join ', ')"
    if (Test-Path $Target) {
        Write-Host "DryRun: existing FreeLLMAPI directory detected -> no checkout, no modification"
    } else {
        Write-Host "DryRun: no existing directory -> would clone and checkout $FreeLLMAPIRef"
    }
    exit 0
}

# Ensure launcher directory exists
if (-not (Test-Path $launcherDest)) {
    New-Item -ItemType Directory -Path $launcherDest -Force | Out-Null
}

# Copy launcher files
Write-Host "Copying launcher files to $launcherDest ..."
foreach ($f in $launcherFiles) {
    $src = Join-Path $SourceDir $f
    $dst = Join-Path $launcherDest $f
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Host "  $f -> $launcherDest"
    } else {
        Write-Warning "Source file not found: $src"
    }
}

if (Test-Path $Target) {
    Write-Host "Existing FreeLLMAPI directory detected at $Target. Skipping clone and checkout."
} else {
    Write-Host "Cloning FreeLLMAPI into $Target ..."
    git clone https://github.com/tashfeenahmed/freellmapi $Target
    if ($LASTEXITCODE -ne 0) {
        Write-Error "git clone failed"
        exit 1
    }
    Write-Host "Checking out pinned commit $FreeLLMAPIRef ..."
    git -C $Target checkout $FreeLLMAPIRef
    if ($LASTEXITCODE -ne 0) {
        Write-Error "git checkout failed"
        exit 1
    }
}

Write-Host "Starting FreeLLMAPI proxy..."
Push-Location $Target
try {
    npm run dev
} finally {
    Pop-Location
}