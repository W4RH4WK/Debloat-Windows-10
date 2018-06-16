#   Description:
# This script disables Cortana while still preserving the ability to use the Start Menu for search

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1


# http://www.thewindowsclub.com/disable-turn-off-cortana-windows-10
force-mkdir "HKLM:\SOFTWARE\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Windows Search" "AllowCortana" 0
force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0
