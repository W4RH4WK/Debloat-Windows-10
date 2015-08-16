#   Description:
# This script redirects telemetry related domains to your nowhere using the
# hosts file. Additionally telemetry is disallows via Group Policies.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Adding telemetry routes to hosts file"
cat "$PSScriptRoot\..\res\telemetry-hosts.txt" >> "$env:systemroot\System32\drivers\etc\hosts"

echo "Disabling telemetry via Group Policies"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000
"@)
