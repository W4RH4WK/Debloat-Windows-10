#   Description:
# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below.

$services = @(
    "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
    "HomeGroupListener"                        # HomeGroup Listener
    "HomeGroupProvider"                        # HomeGroup Provider
    "lfsvc"                                    # Geolocation Service
    "MapsBroker"                               # Downloaded Maps Manager
    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
    "RemoteAccess"                             # Routing and Remote Access
    "RemoteRegistry"                           # Remote Registry
    "SharedAccess"                             # Internet Connection Sharing (ICS)
    "TrkWks"                                   # Distributed Link Tracking Client
    "WbioSrvc"                                 # Windows Biometric Service (required for Fingerprint reader / facial detection)
    #"WlanSvc"                                 # WLAN AutoConfig
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
    "wscsvc"                                   # Windows Security Center Service
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
    "ndu"                                      # Windows Network Data Usage Monitor
    "SSDPSRV"                                  #SSDP Discovery
    "lltdsvc"                                  #Link-Layer Topology Discovery Mapper
    "AXInstSV"                                 #ActiveX Installer
    "AJRouter"                                 #AllJoyn Router Service
    "AppReadiness"                             #App Readiness
    "wlidsvc"                                  #Microsoft Account Sign-in Assistant
    "SmsRouter"                                #Microsoft Windows SMS
    "NcdAutoSetup"                             #Network Connected Devicees Auto-Setup
    "PNRPsvc"                                  #Peer Name Resolution Protocol
    "p2psvc"                                   #Peer Networking Group
    "p2pimsvc"                                 #Peer Networking Identity Manager
    "PNRPAutoReg"                              #PNRP Machine Name Publication Service
    "WalletService"                            #WalletService
    "WMPNetworkSvc"                            #Windows Media Player Network Sharing Service
    "icssvc"                                   #Internet Connection Sharing Service
    "XblAuthManager"                           #Xbox Live Auth Manager
    "XblGameSave"                              #Xbox Live Game Save
    "XboxNetApiSvc"                            #Xbox Net Api
    "DmEnrollmentSvc"                          #Device Management Enrollment Service
    "RetailDemo"                               #Retail Demo
    "LanmanServer"                             #File Print Network Sharing
    "LanmanWorkstation"                        #Workstation - Remote Server SMB
    "seclogon"                                 #Secondary Logon
    "fhsvc"                                    #File History Service
    "CscService"                               #Offline Files
    "WbioSrvc"                                 #Windows Biometric Service
    
    # Services which cannot be disabled
    #"WdNisSvc"
)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}
