cd %~dp0

wimTweak /o /c Microsoft-Windows-MediaPlayer /r
wimTweak /o /c Microsoft-Windows-WindowsMediaPlayer /r
wimTweak /o /c Microsoft-Windows-WMPNetworkSharingService /r

rem YOU NEED TO REBOOT IN ORDER FOR THE CHANGES TO TAKE EFFECT
pause
