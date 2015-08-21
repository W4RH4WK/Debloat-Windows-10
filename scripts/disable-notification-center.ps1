#   Description:
# This script disables the notification center.

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name UseActionCenterExperience -Value 0
