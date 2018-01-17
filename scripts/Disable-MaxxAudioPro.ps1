Disable-ScheduledTask RtHDVBg_PushButton -ErrorAction SilentlyContinue | Out-Null

# Realtek Audio Service
Stop-Service RtkAudioService
Set-Service RtkAudioService -StartupType Disabled

# Waves Audio Services
Stop-Service WavesSysSvc
Set-Service WavesSysSvc -StartupType Disabled

$regFileName = "Disable-MaxxAudioPro.reg"
$regFileContent = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run]
"RtHDVBg_PushButton"=hex:03,00,00,00,0b,34,17,77,53,4c,d3,01
"RtHDVBg_WAVES_SKYLAKE"=hex(3):03,00,00,00,4F,89,38,1E,5D,A1,D2,01
"RTHDVCPL"=hex(3):03,00,00,00,10,C0,D1,1F,5D,A1,D2,01
"WavesSvc"=hex(3):03,00,00,00,F8,39,39,21,5D,A1,D2,01
"@

$regFileContent | Out-file $regFileName
Start-Process -FilePath "regedit.exe" -ArgumentList "/s", """$regFileName""" -Wait
Remove-Item $regFileName
