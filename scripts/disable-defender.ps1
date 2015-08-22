#   Description:
# This script will disable Windows Defender via Group Policies.

echo "Disabling Windows Defender"
mkdir -Force "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" 1
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" "DisableRoutinelyTakingAction" 1
mkdir -Force "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" 1
