#   Description:
# This script will disable the login screen background image

echo "Disabling login screen background"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System]
"DisableLogonBackgroundImage"=dword:00000001
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
rm $regfile
