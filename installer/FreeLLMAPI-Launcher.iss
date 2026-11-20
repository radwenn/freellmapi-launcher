[Setup]
AppVersion={#MyAppVersion}
AppName=FreeLLMAPI Launcher
AppPublisher=FreeLLMAPI Launcher contributors
AppPublisherURL=https://github.com/tashfeenahmed/freellmapi
AppSupportURL=https://github.com/tashfeenahmed/freellmapi
AppUpdatesURL=https://github.com/tashfeenahmed/freellmapi
AppID={{freellmapi-launcher}
DefaultDirName=auto
DisableDirPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
Languages=english french

[Files]
Source: "{src}\*"; Flags: recursesubdirs excludehidden

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "FreeLLMAPILauncher"; ValueString: "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""{app}\launcher.ps1"""

[Run]
Filename: "{app}\setup.ps1"; Description: "Start FreeLLMAPI proxy"; Flags: postinstall runifstillrunning skipifsilent