#   Description:
# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service"
    "DiagTrack"
    "dmwappushservice"
    "HomeGroupListener"
    "HomeGroupProvider"
    "lfsvc"
    "MapsBroker"
    "NetTcpPortSharing"
    "RemoteAccess"
    "RemoteRegistry"
    "SharedAccess"
    "TrkWks"
    "WbioSrvc"
    "WMPNetworkSvc"
    "wscsvc"
    "WSearch"
    "XblAuthManager"
    "XblGameSave"
    "XboxNetApiSvc"

    # Services which cannot be disabled
    #"WdNisSvc"
)

foreach ($service in $services) {
    Get-Service -Name $service | Stop-Service -PassThru | Set-Service -StartupType Disabled
}
