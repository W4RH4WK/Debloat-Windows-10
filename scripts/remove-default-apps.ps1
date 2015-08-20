#   Description:
# This script removes unwanted Apps that come with Windows. If you  do not want
# to remove certain Apps comment out the corresponding lines below.

$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "microsoft.windowscommunicationsapps"
    
    # apps that cannot be removed
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
    
    # apps from Windows 8 upgrade
    "9E2F88E3.Twitter"
    "Flipboard.Flipboard"
    "Microsoft.MinecraftUWP"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
)

echo "Uninstalling default apps"
foreach ($app in $apps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue

    Get-AppXProvisionedPackage -Online |
        where DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

echo "Renaming unremovable apps"
$apps = @(
    "Microsoft.BioEnrollment_cw5n1h2txyewy"
    "Microsoft.XboxGameCallableUI_cw5n1h2txyewy"
    "Microsoft.XboxIdentityProvider_cw5n1h2txyewy"
    "WindowsFeedback_cw5n1h2txyewy"
)

foreach ($app in $apps) {
    mv "$env:WinDir\SystemApps\$app" "$env:WinDir\SystemApps\_$app"
}
