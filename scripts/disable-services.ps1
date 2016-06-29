#   Description:
# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service
    "HomeGroupListener"                        # HomeGroup Listener
    "HomeGroupProvider"                        # HomeGroup Provider
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SharedAccess"                             # Internet Connection Sharing (ICS)
    "TrkWks"                                   # Distributed Link Tracking Client
    "WbioSrvc"                                 # Windows Biometric Service
    #"WlanSvc"                                 # WLAN AutoConfig
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "wscsvc"                                   # Windows Security Center Service
    #"WSearch"                                 # Windows Search
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service

    # Services which cannot be disabled
    #"WdNisSvc"
)

foreach ($service in $services) {
    Get-Service -Name $service -ErrorVariable getServiceError -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled

    # I use the shortened evaluation of the conditions here, if the first is false the second part is not processed.
    # credit: http://powershell.com/cs/forums/t/12721.aspx
    if ($getServiceError -and ($getServiceError | foreach {$_.FullyQualifiedErrorId -like "*NoServiceFoundForGivenName*"}))
    {
        Write-Warning "There is no service named $service."
    }
    else
    {
        Write-Output "Disabled service named $service."
    }
}
