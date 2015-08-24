#   Description:
# This script disables unwanted Windows features. If you do not want to
# disable certain features comment out the corresponding lines below.

echo "Disabling so-called Windows Features"
$features = @(
    "Internet-Explorer-Optional-amd64"
    "MediaPlayback"
    "WindowsMediaPlayer"
    "WorkFolders-Client"
)
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $features

echo "Disabling Windows Defender via Group Policies"
mkdir -Force "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" 1
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" "DisableRoutinelyTakingAction" 1
mkdir -Force "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" 1

echo "Disable Notification Center"
sp "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" UseActionCenterExperience 0

echo "Disable startmenu search features"
mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\Windows Search"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowCortana 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" DisableWebSearch 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowSearchToUseLocation 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" ConnectedSearchUseWeb 0

# This will disable the startmenu search feature.
#echo "Disable searchUI.exe"
#taskkill.exe /F /IM "SearchUI.exe"
#foreach ($_ in (0..15)) {
#    if (Test-Path "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy") {
#        mv "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" `
#            "$env:windir\SystemApps\_Microsoft.Windows.Cortana_cw5n1h2txyewy" `
#            -ErrorAction SilentlyContinue
#    } else {
#        break
#    }
#}

echo "Disabling telemetry via Group Policies"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0

#echo "Disable AutoRun"
#mkdir -Force "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
#sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff
#mkdir -Force "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
#sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff
