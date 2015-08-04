#	Description:
# This script will remove and disable OneDrive integration.

echo "Kill OneDrive process"
kill "OneDrive.exe"

echo "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
	& "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
	& "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}

echo "Removing OneDrive leftovers"
rm -r -Force "$env:localappdata\Microsoft\OneDrive"
rm -r -Force "$env:programdata\Microsoft OneDrive"
rm -r -Force "$env:userprofile\OneDrive"
rm -r -Force "C:\OneDriveTemp"

echo "Disable OneDrive via Group Policies"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive]
"DisableFileSyncNGSC"=dword:00000001
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
regedit /s $regfile
rm $regfile