#   Description:
# This script restores the old volume slider.

echo "Restoring old volume slider"
mkdir -Force "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC"
sp "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC" "EnableMtcUvc" 0
