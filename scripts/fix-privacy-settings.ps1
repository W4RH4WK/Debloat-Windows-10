#	Description:
# This script will try to fix many of the privacy settings for the user.

echo "Defuse Windows search settings"
Set-WindowsSearchSetting -EnableWebResultsSetting $false

echo "Set general privacy options"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\International\User Profile]
"HttpAcceptLanguageOptOut"=dword:00000001

[HKEY_CURRENT_USER\Printers\Defaults]
"NetID"="{00000000-0000-0000-0000-000000000000}"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TIPC]
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost]
"EnableWebContentEvaluation"=dword:00000000

"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
regedit /s $regfile
rm $regfile

echo "Disable synchronisation of settings"
$reg = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync]
"BackupPolicy"=dword:0000003c
"DeviceMetadataUploaded"=dword:00000000
"SettingsVersion"=dword:00000001
"PriorLogons"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync]
"Enabled"=dword:00000000
"SettingsVersion"=dword:00000003

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState]
"Enabled"=dword:00000000
"SettingsVersion"=dword:00000003

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows]
"SettingsVersion"=dword:00000003
"Enabled"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\SyncData]
"LastBackgroundUpload"=hex:aa,4f,9c,80,e0,cd,d0,01
"@
$regfile = "$env:windir\Temp\registry.reg"
$reg | Out-File $regfile
regedit /s $regfile
rm $regfile
