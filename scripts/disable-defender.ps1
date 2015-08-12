#   Description:
# This script will disable Windows Defender via Group Policies.

Import-Module $PSScriptRoot\..\lib\reg-helper.psm1

echo "Disabling Windows Defender"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender]
"DisableAntiSpyware"=dword:00000001
"DisableRoutinelyTakingAction"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Policy Manager]

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection]
"DisableRealtimeMonitoring"=dword:00000001
"@)
