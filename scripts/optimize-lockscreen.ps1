#   Description:
# This script disables the new lock screen and login screen background
# image.

echo "Disabling login screen background image"
mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\System"
sp "HKLM:\Software\Policies\Microsoft\Windows\System" "DisableLogonBackgroundImage" 1

echo "Disabling new lock screen"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" 1
