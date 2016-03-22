#   Description
# This script will apply MarkC's mouse acceleration fix (for 100% DPI) and
# disable some accessibility features regarding keyboard input.  Additional
# some UI elements will be changed.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

echo "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

echo "Apply MarkC's mouse acceleration fix"
sp "HKCU:\Control Panel\Mouse" "MouseSensitivity" "10"
sp "HKCU:\Control Panel\Mouse" "MouseSpeed" "0"
sp "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0"
sp "HKCU:\Control Panel\Mouse" "MouseThreshold2" "0"
sp "HKCU:\Control Panel\Mouse" "SmoothMouseXCurve" ([byte[]](0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xCC, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00,
0x80, 0x99, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x66, 0x26, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00))
sp "HKCU:\Control Panel\Mouse" "SmoothMouseYCurve" ([byte[]](0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA8, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00))

echo "Disable mouse pointer hiding"
sp "HKCU:\Control Panel\Desktop" "UserPreferencesMask" ([byte[]](0x9e,
0x1e, 0x06, 0x80, 0x12, 0x00, 0x00, 0x00))

echo "Disable easy access keyboard stuff"
sp "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
sp "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"
sp "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"

echo "Restoring old volume slider"
mkdir -Force "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC"
sp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC" "EnableMtcUvc" 0

echo "Setting folder view options"
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0

echo "Setting default explorer view to This PC"
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 0

# Explorer will throw an error if quick acess is removed and default view has
# not been changed to This PC.
#echo "Removing Quick Access from explorer"
#Takeown-Registry("HKEY_CLASSES_ROOT\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder")
#New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
#sp "HKCR:\CLSID\{679f85cb-0220-4080-b29b-5540cc05aab6}\ShellFolder" "Attributes" 0xa0600000
#Remove-PSDrive "HKCR"

echo "Removing user folders under This PC"
# Remove Desktop from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
# Remove Documents from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}"
# Remove Downloads from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}"
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}"
# Remove Music from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"
# Remove Pictures from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"
# Remove Videos from This PC
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
rm "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
rm "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"

echo "Disabling login screen background image"
mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\System"
sp "HKLM:\Software\Policies\Microsoft\Windows\System" "DisableLogonBackgroundImage" 1

echo "Disabling new lock screen"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" 1

echo "Disable startmenu search features"
mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\Windows Search"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowCortana 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" DisableWebSearch 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowSearchToUseLocation 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" ConnectedSearchUseWeb 0

echo "Disable AutoRun"
mkdir -Force "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff
mkdir -Force "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 0xff

#echo "Disabling tile push notification"
#mkdir -Force "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
#sp "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" "NoTileApplicationNotification" 1

#echo "Disabling screen saver"
#sp "HKCU:\Control Panel\Desktop\" "ScreenSaveActive" "0"

#echo "Use legacy advanced boot menu"
#bcdedit.exe /set `{current`} bootmenupolicy Legacy
