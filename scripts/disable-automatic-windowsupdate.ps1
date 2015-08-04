#   Description:
# This script disables automatic downloading and installation of Windows
# updates via Group Policies.

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
regedit /s $regfile
rm $regfile