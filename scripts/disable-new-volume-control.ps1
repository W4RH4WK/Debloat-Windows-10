#   Description:
# This script restores the old volume slider.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Restoring old volume slider"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC]
"EnableMtcUvc"=dword:00000000
"@)
