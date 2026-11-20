$ErrorActionPreference = 'Stop'

$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath "FreeLLMAPI.lnk"

$launcherDir = $PSScriptRoot
$powershellExe = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
$scriptPath = Join-Path $launcherDir "launcher.ps1"
$iconPath = Join-Path $launcherDir "icon.ico"

$wsh = New-Object -ComObject WScript.Shell
$shortcut = $wsh.CreateShortcut($shortcutPath)

$shortcut.TargetPath = $powershellExe
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$shortcut.WorkingDirectory = $launcherDir
$shortcut.IconLocation = $iconPath
$shortcut.Description = "Lanceur FreeLLMAPI"

$shortcut.Save()

Write-Host "Raccourci cree sur le Bureau : $shortcutPath"