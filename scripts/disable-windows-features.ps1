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

echo "Disable searchUI.exe"
taskkill.exe /F /IM "SearchUI.exe"
# try to rename folder while SearchUI is restarting
foreach ($_ in (0..15)) {
    if (Test-Path "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy") {
        mv "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" `
            "$env:windir\SystemApps\_Microsoft.Windows.Cortana_cw5n1h2txyewy" `
            -ErrorAction SilentlyContinue
    } else {
        break
    }
}

echo "Adding telemetry domains to hosts file"
$hosts = cat "$PSScriptRoot\..\res\telemetry-hosts.txt"
$hosts_file = "$env:systemroot\System32\drivers\etc\hosts"
[ipaddress[]] $ips = @()
foreach ($h in $hosts) {
    try {
        # store for next part
        $ips += [ipaddress]$h
    } catch [System.InvalidCastException] {
        $contaisHost = Select-String -Path $hosts_file -Pattern $h
        If (-Not $contaisHost) {
            # can be redirected by hosts
            echo "0.0.0.0 $h" | Out-File -Encoding ASCII -Append $hosts_file
        }
    }
}
echo "Adding telemetry ips to firewall"
Remove-NetFirewallRule -DisplayName "Block Telemetry IPs" -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Block Telemetry IPs" -Direction Outbound `
    -Action Block -RemoteAddress ([string[]]$ips)

echo "Disabling telemetry via Group Policies"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
