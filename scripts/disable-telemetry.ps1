#   Description:
# This script redirects telemetry related domains to your nowhere using the
# hosts file. Hard coded telemetry related IPs are blocked by Windows firewall.
# Additionally telemetry is disallows via Group Policies.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

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
        If(-Not $contaisHost) {
            # can be redirected by hosts
            echo "0.0.0.0 $h" | Out-File -Encoding ASCII -Append $hosts_file
        }
    }
}

echo "Adding telemetry ips to firewall"
Remove-NetFirewallRule -ErrorAction SilentlyContinue -DisplayName "Block Telemetry IPs"
New-NetFirewallRule -DisplayName "Block Telemetry IPs" -Direction Outbound `
    -Action Block -RemoteAddress ([string[]]$ips)

echo "Disabling telemetry via Group Policies"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000
"@)
