#   Description:
# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below.

$services = @(
    "HomeGroupListener"
    "HomeGroupProvider"
    "MapsBroker"
    "NetTcpPortSharing"
    "RemoteAccess"
    "RemoteRegistry"
    "SharedAccess"
    "WbioSrvc"
    "XblAuthManager"
    "XblGameSave"
    "XboxNetApiSvc"
    "dmwappushservice"
    "lfsvc"
    #"wscsvc"
)

foreach ($service in $services) {
    Get-Service -Name $service | Set-Service -StartupType Disabled
}
