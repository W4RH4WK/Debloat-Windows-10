#   Description:
# This script will remove and disable OneDrive integration.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Kill OneDrive process"
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

echo "Remove OneDrive"
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}

echo "Removing OneDrive leftovers"
rm -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
rm -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
rm -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
rm -Recurse -Force -ErrorAction SilentlyContinue "C:\OneDriveTemp"

echo "Disable OneDrive via Group Policies"
if (-Not (Get-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\" -ErrorAction SilentlyContinue)) {
    New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\" -Name DisableFileSyncNGSC -Value 1

echo "Remove Onedrive from explorer sidebar"
Import-Registry(@"
[HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:00000000

[HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:00000000
"@)

echo "Removing startmenu entry"
rm -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

echo "Restarting explorer"
start "explorer.exe"
