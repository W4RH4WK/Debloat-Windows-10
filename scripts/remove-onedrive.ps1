#	Description:
# This script removes OneDrive files from your system.

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