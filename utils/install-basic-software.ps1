#   Description:
# This script will use Windows package manager to bootstrap Chocolatey and
# install a list of packages. Script will also install Sysinternals Utilities
# into your default drive's root directory.

$packages = @(
  "notepadplusplus.install"
  "peazip.install"
  #"7zip.install"
  #"aimp"
  #"audacity"
  #"autoit"
  #"classic-shell"
  #"filezilla"
  #"firefox"
  #"gimp"
  #"google-chrome-x64"
  #"imgburn"
  #"keepass.install"
  #"paint.net"
  #"putty"
  #"python"
  #"qbittorrent"
  #"speedcrunch"
  #"sysinternals"
  #"thunderbird"
  #"vlc"
  #"windirstat"
  #"wireshark"
)

Write-Output "Setting up Chocolatey software package manager"
Get-PackageProvider -Name chocolatey -Force

Write-Output "Setting up Full Chocolatey Install"
Install-Package -Name Chocolatey -Force -ProviderName chocolatey
$chocopath = (Get-Package chocolatey | Where-Object { $_.Name -eq "chocolatey" } | Select-Object @{ N = "Source"; E = { ((($a = ($_.Source -split "\\"))[0..($a.length - 2)]) -join "\"),"Tools\chocolateyInstall" -join "\" } } | Select-Object -ExpandProperty Source)
& $chocopath "upgrade all -y"
choco install chocolatey-core.extension --force

Write-Output "Creating daily task to automatically upgrade Chocolatey packages"
# adapted from https://blogs.technet.microsoft.com/heyscriptingguy/2013/11/23/using-scheduled-tasks-and-scheduled-jobs-in-powershell/
$ScheduledJob = @{
  Name = "Chocolatey Daily Upgrade"
  ScriptBlock = { choco upgrade all -y }
  Trigger = New-JobTrigger -Daily -at 2am
  ScheduledJobOption = New-ScheduledJobOption -RunElevated -MultipleInstancePolicy StopExisting -RequireNetwork
}
Register-ScheduledJob @ScheduledJob

Write-Output "Installing Packages"
$packages | ForEach-Object { choco install $_ --force -y }

Write-Output "Installing Sysinternals Utilities to C:\Sysinternals"
$download_uri = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$wc = New-Object net.webclient
$wc.downloadFile($download_uri,"/SysinternalsSuite.zip")
Add-Type -AssemblyName "system.io.compression.filesystem"
[io.compression.zipfile]::extracttodirectory("/SysinternalsSuite.zip","/Sysinternals")
Write-Output "Removing zipfile"
rm "/SysinternalsSuite.zip"
