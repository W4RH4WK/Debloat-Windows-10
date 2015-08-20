#   Description: 
# This script will disable certain unwanted startmenu search features

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\' -Name AllowCortana -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\' -Name DisableWebSearch -Value 1
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\' -Name AllowSearchToUseLocation -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\' -Name ConnectedSearchUseWeb -Value 0

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Windows Search\' -Name AllowCortana -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Windows Search\' -Name DisableWebSearch -Value 1
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Windows Search\' -Name AllowSearchToUseLocation -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Windows Search\' -Name ConnectedSearchUseWeb -Value 0
