#   Description:
# This script disables automatic downloading and installation of Windows
# updates via Group Policies. Additinally seeding updates to other computers is
# disables.

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

echo "Disable seeding of updates to other computers"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization]
"SystemSettingsDownloadMode"=dword:00000003
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
rm $regfile
