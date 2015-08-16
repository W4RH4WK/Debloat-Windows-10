#   Description:
# This script redirects telemetry related domains to your nowhere using the
# hosts file. Additionally telemetry is disallows via Group Policies.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Adding telemetry domains to hosts file"
$hosts = cat "$PSScriptRoot\..\res\telemetry-hosts.txt"
[ipaddress[]] $ips = @()
foreach ($h in $hosts) {
    try {
        # store for next part
        $ips += [ipaddress]$h
    } catch [System.InvalidCastException] {
        # can be redirected by hosts
        echo "0.0.0.0 $h" >> "$env:systemroot\System32\drivers\etc\hosts"
    }
}

echo "Adding telemetry ips to firewall"
New-NetFirewallRule -DisplayName "Block Telemetry IPs" -Direction Outbound `
    -Action Block -RemoteAddress ([string[]]$ips)

echo "Disabling telemetry via Group Policies"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000
"@)
