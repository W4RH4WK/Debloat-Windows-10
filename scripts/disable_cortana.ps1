
# http://www.thewindowsclub.com/disable-turn-off-cortana-windows-10
force-mkdir "HKLM:\SOFTWARE\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Windows Search" "AllowCortana" 0
force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0
