#   Description:
# This script optimizes Windows updates by disabling automatic download and
# seeding updates to other computers.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Disable automatic download and installation of Windows updates"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU]
"NoAutoUpdate"=dword:00000000
"AUOptions"=dword:00000002
"ScheduledInstallDay"=dword:00000000
"ScheduledInstallTime"=dword:00000003
"@)

echo "Disable seeding of updates to other computers via Group Policies"
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization]
"DODownloadMode"=dword:00000000
"@)
