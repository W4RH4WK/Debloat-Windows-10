#   Description:
# This script will try to fix many of the privacy settings for the user. This
# is work in progress!


function Import-Registry($reg) {
    # add reg file hander
    $reg = "Windows Registry Editor Version 5.00`r`n`r`n" + $reg

    # store, import and remove reg file
    $regfile = "$env:windir\Temp\registry.reg"
    $reg | Out-File $regfile
    Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
    rm $regfile
}

function Takeown-Registry($key) {
    # TODO works only for LocalMachine for now
    $key = $key.substring(19)

    # set owner
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows Defender\Spynet", "ReadWriteSubTree", "TakeOwnership")
    $owner = [Security.Principal.NTAccount]"Administrators"
    $acl = $key.GetAccessControl()
    $acl.SetOwner($owner)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule("Administrators", "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}

function Enable-Privilege {
    param($Privilege)
    $Definition = @"
    using System;
    using System.Runtime.InteropServices;

    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);

        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }

        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@
    $ProcessHandle = (Get-Process -id $pid).Handle
    $type = Add-Type $definition -PassThru
    $type[0]::EnablePrivilege($processHandle, $Privilege)
}


echo "Elevating priviledges for this process"
do {} until (Enable-Privilege SeTakeOwnershipPrivilege)

echo "Defuse Windows search settings"
Set-WindowsSearchSetting -EnableWebResultsSetting $false

echo "Set general privacy options"
Import-Registry(@"
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
"@)

echo "Disable synchronisation of settings"
Import-Registry(@"
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
"@)

echo "Set privacy policy accepted state to 0"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Personalization]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Personalization\Settings]
"AcceptedPrivacyPolicy"=dword:00000000
"@)

echo "Do not scan contact informations"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore]
"HarvestContacts"=dword:00000000
"@)

echo "Disable background access of default apps"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Office.OneNote_17.4229.10061.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.People_1.10241.0.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.ContentDeliveryManager_10.0.10240.16384_neutral_neutral_cw5n1h2txyewy]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.ContentDeliveryManager_10.0.10240.16384_neutral_neutral_cw5n1h2txyewy\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy!App]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Cortana_1.4.8.176_neutral_neutral_cw5n1h2txyewy]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Cortana_1.4.8.176_neutral_neutral_cw5n1h2txyewy\Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_15.721.12350.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.Windows.Photos_15.803.16240.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsAlarms_10.1506.19010.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\microsoft.windowscommunicationsapps_17.6020.42011.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsMaps_4.1506.50715.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsPhone_10.1507.17010.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsStore_2015.7.1.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsStore_2015.8.3.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.WindowsStore_2015.8.3.0_x64__8wekyb3d8bbwe\Microsoft.WindowsStore_8wekyb3d8bbwe!App]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxApp_5.6.17000.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.XboxApp_7.7.29027.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneMusic_3.6.10841.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.ZuneMusic_3.6.12101.0_x64__8wekyb3d8bbwe]
"Disabled"=dword:00000001
"@)

echo "Denying device access"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled]
"Type"="LooselyCoupled"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{021fd406-b019-4de8-887d-2f202792af23}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{0B9F1048-B94B-DC9A-4ED7-FE4FED3A0DEB}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{6ac27878-a6fa-4155-ba85-f98f491d4f33}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9D9E0118-1807-4F2E-96E4-2CE57142E196}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B19F89AF-E3EB-444B-8DEA-202575A71599}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E83AF229-8640-4D18-A213-E22675EBB2C3}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{F9020CFE-86CE-4D92-9D32-22E537847CF9}]
"Type"="InterfaceClass"
"Value"="Deny"
"InitialAppValue"="Unspecified"
"@)

echo "Disable location sensor"
Import-Registry(@"
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions]

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}]
"SensorPermissionState"=dword:00000000
"@)

echo "Disable submission of Windows Defender findings"
Takeown-Registry("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet")
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet]
"SpyNetReporting"=dword:00000000
"SubmitSamplesConsent"=dword:00000000
"@)

echo "Do not share wifi networks"
$user = New-Object System.Security.Principal.NTAccount($env:UserName)
$sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).value
Import-Registry(@"
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\$sid]
"FeatureStates"=dword:0000033c
"@)
