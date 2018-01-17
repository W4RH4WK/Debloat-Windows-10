#   Description:
# This script optimizes Windows updates by disabling automatic download and
# seeding updates to other computers.

echo "Disable seeding of updates to other computers via Group Policies"
mkdir -Force "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
