#   Description:
# This script will do some optimization on the Windows start menu.

echo "Disabling tile push notification"
mkdir -Force "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
sp "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" "NoTileApplicationNotification" 1
