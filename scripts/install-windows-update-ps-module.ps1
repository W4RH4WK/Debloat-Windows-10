#   Description:
# This script will setup the Windows Update Powershell module. With it you will
# be able to download, install, uninstall and hide Windows updates using
# Powershell. For a list of commands invoke
# `PS> Get-Command -Module PSWindowsUpdate`.

$ErrorActionPreference = "Stop"

$download_uri = "https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/43/PSWindowsUpdate.zip"

echo "Downloading PSWindowsUpdate zipfile"

# TODO replace this with wget when it works again on a clean install
$wc = new-object net.webclient
$wc.DownloadFile($download_uri, "$PSHOME/Modules/PSWindowsUpdate.zip")

echo "Extracting PSWindowsUpdate zipfile"
Add-Type -AssemblyName "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("$PSHOME/Modules/PSWindowsUpdate.zip", "$PSHOME/Modules/")

echo "Removing zipfile"
rm "$PSHOME/Modules/PSWindowsUpdate.zip"

echo "Import Module automatically when Powershell starts"
echo "Import-Module PSWindowsUpdate" >> "$PSHOME/profile.ps1"
