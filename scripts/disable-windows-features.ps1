#   Description:
# This script disables unwanted Windows features. If you do not want to
# disable certain features comment out the corresponding lines below.

$features = @(
    "MediaPlayback"
    "WindowsMediaPlayer"
    "WorkFolders-Client"
)

Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $features
