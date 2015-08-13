#   Description:
# This script disables the new lock screen via Group Policies.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization]
"NoLockScreen"=dword:00000001
"@)
