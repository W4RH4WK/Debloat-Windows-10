#   Description:
# This script optimizes Windows updates by disabling automatic download and
# seeding updates to other computers.

Import-Module $PSScriptRoot\..\lib\reg-helper.psm1

echo "Disable automatic download and installation of Windows updates"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU]
"NoAutoUpdate"=dword:00000000
"AUOptions"=dword:00000002
"ScheduledInstallDay"=dword:00000000
"ScheduledInstallTime"=dword:00000003
"@)

echo "Disable seeding of updates to other computers"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization]
"SystemSettingsDownloadMode"=dword:00000003
"@)
