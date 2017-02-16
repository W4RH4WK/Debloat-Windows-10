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

echo "Setting up Chocolatey software package manager"
Get-PackageProvider -Name chocolatey -Force

echo "Creating daily task to automatically upgrade Chocolatey packages"
# adapted from https://blogs.technet.microsoft.com/heyscriptingguy/2013/11/23/using-scheduled-tasks-and-scheduled-jobs-in-powershell/
$taskName = "Chocolatey Daily Upgrade"
$taskAction = New-ScheduledTaskAction -Execute C:\programdata\chocolatey\choco.exe -Argument "upgrade all -y"
$taskTrigger = New-ScheduledTaskTrigger -At 2am -Daily
$taskUser = "Admin"
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -User $taskUser

echo "Installing Packages"
Install-Package -Name $packages -Force -ProviderName chocolatey

echo "Installing Sysinternals Utilities to C:\Sysinternals"
$download_uri = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$wc = new-object net.webclient
$wc.DownloadFile($download_uri, "/SysinternalsSuite.zip")
Add-Type -AssemblyName "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("/SysinternalsSuite.zip", "/Sysinternals")
echo "Removing zipfile"
rm "/SysinternalsSuite.zip"
