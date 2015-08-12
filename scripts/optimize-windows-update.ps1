#   Description:
# This script optimizes Windows updates by disabling automatic download and
# seeding updates to other computers.

echo "Disable automatic download and installation of Windows updates"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU]
"NoAutoUpdate"=dword:00000000
"AUOptions"=dword:00000002
"ScheduledInstallDay"=dword:00000000
"ScheduledInstallTime"=dword:00000003
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
rm $regfile

echo "Disable seeding of updates to other computers via Group Policies"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization]
"DODownloadMode"=dword:00000000
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
rm $regfile
