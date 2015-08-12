#   Description:
# This script will disable the login screen background image

Import-Module $PSScriptRoot\..\lib\reg-helper.psm1

echo "Disabling login screen background image"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System]
"DisableLogonBackgroundImage"=dword:00000001
"@)
