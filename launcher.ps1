param(
    [string]$Lang
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Détection de la langue : paramètre explicit ou Get-UICulture
$selectedLang = if (-not [string]::IsNullOrWhiteSpace($Lang)) {
    $Lang.Trim().ToLower()
} else {
    try { (Get-UICulture).TwoLetterISOLanguageName.ToLower() } catch { "en" }
}

if ($selectedLang -like "fr*") {
    $selectedLang = "fr"
} elseif ($selectedLang -like "ar*") {
    $selectedLang = "ar"
} else {
    $selectedLang = "en"
}

$i18n = @{
    en = @{
        title   = "FreeLLMAPI"
        start   = "Start"
        stop    = "Shutdown"
        running = "Running"
        stopped = "Stopped"
    }
    fr = @{
        title   = "FreeLLMAPI"
        start   = "Démarrer"
        stop    = "Arrêter"
        running = "En marche"
        stopped = "Arrêté"
    }
    ar = @{
        title   = "FreeLLMAPI"
        start   = "تشغيل"
        stop    = "إيقاف"
        running = "يعمل"
        stopped = "متوقف"
    }
}

$t = $i18n[$selectedLang]

function Test-Running {
    [bool](Get-NetTCPConnection -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue)
}

$form = New-Object Windows.Forms.Form
$form.Text = $t.title
$form.Size = New-Object Drawing.Size(280,170)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

if ($selectedLang -eq "ar") {
    $form.RightToLeft = [System.Windows.Forms.RightToLeft]::Yes
    $form.RightToLeftLayout = $true
}

$iconPath = Join-Path $PSScriptRoot "icon.ico"
if (Test-Path $iconPath) { $form.Icon = New-Object Drawing.Icon($iconPath) }

$status = New-Object Windows.Forms.Label
$status.Location = New-Object Drawing.Point(20,15)
$status.Size = New-Object Drawing.Size(230,25)
$status.Font = New-Object Drawing.Font("Segoe UI",11,[Drawing.FontStyle]::Bold)
$form.Controls.Add($status)

$start = New-Object Windows.Forms.Button
$start.Text = $t.start
$start.Location = New-Object Drawing.Point(20,55)
$start.Size = New-Object Drawing.Size(105,45)
$start.Add_Click({
    if (-not (Test-Running)) {
        Start-Process cmd.exe -ArgumentList "/c `"$PSScriptRoot\start.bat`"" -WindowStyle Hidden
    }
})
$form.Controls.Add($start)

$stop = New-Object Windows.Forms.Button
$stop.Text = $t.stop
$stop.Location = New-Object Drawing.Point(140,55)
$stop.Size = New-Object Drawing.Size(105,45)
$stop.Add_Click({
    Start-Process cmd.exe -ArgumentList "/c `"$PSScriptRoot\stop.bat`"" -WindowStyle Hidden
})
$form.Controls.Add($stop)

$timer = New-Object Windows.Forms.Timer
$timer.Interval = 2000
$timer.Add_Tick({
    $dot = [string][char]0x25CF
    if (Test-Running) {
        $status.Text = "$dot $($t.running)"
        $status.ForeColor = "Green"
    } else {
        $status.Text = "$dot $($t.stopped)"
        $status.ForeColor = "Red"
    }
})
$timer.Start()

$form.ShowDialog() | Out-Null