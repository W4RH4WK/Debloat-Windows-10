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

echo "Removing Windows Defender context menu item"
si "HKLM:\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" ""

echo "Disable Notification Center"
sp "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" UseActionCenterExperience 0

echo "Disable startmenu search features"
mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\Windows Search"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowCortana 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" DisableWebSearch 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowSearchToUseLocation 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" ConnectedSearchUseWeb 0

echo "Disabling telemetry via Group Policies"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0

#echo "Disable AutoRun"
#mkdir -Force "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
#sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff
#mkdir -Force "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
#sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff
