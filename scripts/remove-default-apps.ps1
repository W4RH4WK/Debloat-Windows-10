#   Description: 
# This script removes unwanted Apps that come with Windows. If you  do not want
# to remove certain Apps comment out the corresponding lines below.
# Original Author: W4RH4WK
# Script Source: https://github.com/W4RH4WK/Debloat-Windows-10
# 2018.01.18: William Myers: Moddified code to try a pass within user context, modified verbosity to only output removal of presently installed apps.
# 2018.01.19: William Myers: Modified script to only attempt to run elevated portion if the user has admin rights on the system. 
# this is particularly useful for SCCM or other deployment mechanisms where you want to remove apps as a logged on user that does not have admin rights.



################## User Definable Variables

# Specify where to save a log file (this should be a location that users can write to)
$LogFilePath = "$ENV:SystemDrive\IT\Logs\AppXRemoval.log"

# Import modules
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1

# Modern apps to remove. comment out (#) applications that you do not want removed.
$apps = @(
    ## default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.OneNote"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.SkypeApp"
    "Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.WindowsStore"
    "Microsoft.XboxApp"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "microsoft.windowscommunicationsapps"
    "Microsoft.MinecraftUWP"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.NetworkSpeedTest"
    
    ## Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"


    ## Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingTravel"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.WindowsReadingList"

    ## Restone2 apps
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MSPaint" # Paint 3D
    "Microsoft.Microsoft3DViewer"
    "61908RichardWalters.Calculator" # Calculator 2
    "Microsoft.BingTranslator"


    ## non-Microsoft
    "9E2F88E3.Twitter"
    "PandoraMediaInc.29680B314EFC2"
    "Flipboard.Flipboard"
    "ShazamEntertainmentLtd.Shazam"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "king.com.*"
    "ClearChannelRadioDigital.iHeartRadio"
    "4DF9E0F8.Netflix"
    "6Wunderkinder.Wunderlist"
    "Drawboard.DrawboardPDF"
    "2FE3CB00.PicsArt-PhotoStudio"
    "D52A8D61.FarmVille2CountryEscape"
    "TuneIn.TuneInRadio"
    "GAMELOFTSA.Asphalt8Airborne"
    "TheNewYorkTimes.NYTCrossword"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "Facebook.Facebook"
    "flaregamesGmbH.RoyalRevolt2"
    "Playtika.CaesarsSlotsFreeCasino"
    "A278AB0D.MarchofEmpires"
    "KeeperSecurityInc.Keeper"
    "ThumbmunkeysLtd.PhototasticCollage"
    "XINGAG.XING"
    "89006A2E.AutodeskSketchBook"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "46928bounde.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "DolbyLaboratories.DolbyAccess"
    "SpotifyAB.SpotifyMusic"
    "A278AB0D.DisneyMagicKingdoms"
    "WinZipComputing.WinZipUniversal"
    "AdobeSystemsIncorporated.AdobePhotoshopExpress"


    ## apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"
)



#################### Script ####################  

# Create the log file folder if it does not exist
if (!(Test-Path (Split-Path -parent $LogFilePath))){
	New-Item -Path (Split-Path -parent $LogFilePath) -ItemType Directory
}

get-date |Tee-Object -FilePath $LogFilePath -Append
Write-Output "Uninstalling default apps" |Tee-Object -FilePath $LogFilePath -Append

# CurrentUser
foreach ($app in $apps) {
   
   # Attempt to remove the apps for the current user
    $AppXInstall = Get-AppxPackage -Name $app -EA Continue 
    if ($AppXInstall){
        Write-Output "Trying to remove $app for $ENV:UserName" |Tee-Object -FilePath $LogFilePath -Append

        $AppXInstall | Remove-AppxPackage 
    }

}

# All users
# Determine if the user is an admin before proceeding.
IF (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

    [Security.Principal.WindowsBuiltInRole] "Administrator")){

	Write-Output "Elevating privileges for this process" |Tee-Object -FilePath $LogFilePath -Append
	do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

	foreach ($app in $apps) {
	   
	   # Attempt to remove the apps for all users (This will fail if a user has downloaded any updates for an app
		$AppXInstall = Get-AppxPackage -Name $app -AllUsers -EA Continue 
		if ($AppXInstall){
		 Write-Output "Trying to remove $app for all users" |Tee-Object -FilePath $LogFilePath -Append

			$AppXInstall | Remove-AppxPackage -AllUsers
			Get-AppXProvisionedPackage -Online |
				Where-Object DisplayName -EQ $app |
				Remove-AppxProvisionedPackage -Online
		}

	}

	# Prevents "Suggested Applications" returning
	force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content"
	Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Cloud Content" "DisableWindowsConsumerFeatures" 1

} ELSE {

	Write-Output "User does not have administrative rights on the system, skipping the step to remove apps for other users" |Tee-Object -FilePath $LogFilePath -Append

}
