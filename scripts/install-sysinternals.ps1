#   Description:
# This script installs the sysinternals suit into your default drive's root
# directory.

$ErrorActionPreference = "Stop"

$download_uri = "https://download.sysinternals.com/files/SysinternalsSuite.zip"

echo "Downloading SysinternalsSuite zipfile"

# TODO replace this with wget when it works again on a clean install
$wc = new-object net.webclient
$wc.DownloadFile($download_uri, "/SysinternalsSuite.zip")

echo "Extracting SysinternalsSuite zipfile"
Add-Type -AssemblyName "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("/SysinternalsSuite.zip", "/Sysinternals")

echo "Removing zipfile"
rm "/SysinternalsSuite.zip"
