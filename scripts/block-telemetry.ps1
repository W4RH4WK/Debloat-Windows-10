#   Description:
# This script blocks telemetry related domains via the hosts file and related
# IPs via Windows Firewall.
#
# Please note that adding these domains may break certain software like iTunes
# or Skype. As this issue is location dependent for some domains, they are not
# commented by default. The domains known to cause issues marked accordingly.
# Please see the related issue:
# <https://github.com/W4RH4WK/Debloat-Windows-10/issues/79>

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1

Write-Output "Disabling telemetry via Group Policies"
New-FolderForced -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0

# Entries related to Akamai have been reported to cause issues with Widevine
# DRM.

Write-Output "Adding telemetry domains to hosts file"
$hosts_file = "$env:systemroot\System32\drivers\etc\hosts"
$domains = @(Get-Content $PSScriptRoot\..\blocklists\telemetry-domains.txt)
Write-Output "" | Out-File -Encoding ASCII -Append $hosts_file
foreach ($domain in $domains)
{
    if (-Not (Select-String -Path $hosts_file -Pattern $domain)) {
        if ($domain -notlike "#*" -and $domain -ne "" -and $domain -ne $null) {
            Write-Output "0.0.0.0 $domain" | Out-File -Encoding ASCII -Append $hosts_file
        }
    }
}

Write-Output "Adding telemetry ips to firewall"
$ips = @(Get-Content $PSScriptRoot\..\blocklists\telemetry-ips.txt)
$ips = foreach ($ip in $ips) {
    if ($ip -notlike "#*" -and $ip -ne "" -and $ip -ne $null) {
        $ip
    }
}

Remove-NetFirewallRule -DisplayName "Block Telemetry IPs" -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "Block Telemetry IPs" -Direction Outbound `
    -Action Block -RemoteAddress ([string[]]$ips)
