#   Description:
# This script will use Windows package manager manager to bootstrap chocolatey
# and install a list of packages.

$packages = @(
    "7zip.install"
    "notepadplusplus.install"
    #"aimp"
    #"audacity"
    #"autoit"
    #"filezilla"
    #"gimp"
    #"google-chrome-x64"
    #"imgburn"
    #"keepass.install"
    #"paint.net"
    #"putty"
    #"python"
    #"qbittorrent"
    #"thunderbird"
    #"vlc"
    #"windirstat"
    #"wireshark"
)

echo "Setting up Chocolatey"
Get-PackageProvider -Name chocolatey -Force

echo "Installing Packages"
Install-Package -Name $packages -Force
