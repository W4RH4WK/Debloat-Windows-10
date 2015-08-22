#   Description:
# This script will disable certain unwanted startmenu search features.

mkdir -Force "HKLM:\Software\Policies\Microsoft\Windows\Windows Search"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowCortana 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" DisableWebSearch 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" AllowSearchToUseLocation 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" ConnectedSearchUseWeb 0
