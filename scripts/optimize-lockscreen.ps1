#   Description:
# This script disables the new lock screen and login screen background
# image.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Disabling login screen background image"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System]
"DisableLogonBackgroundImage"=dword:00000001
"@)

echo "Disabling new lock screen"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization]
"NoLockScreen"=dword:00000001
"@)
