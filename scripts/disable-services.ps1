#   Description:
# This script disables unwanted Windows services. If you do not want to disable
# certain services comment out the corresponding lines below. like this #use hastag to comment

$services = @(
    "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
    "DiagTrack"                                    # Diagnostics Tracking Service
    "dmwappushservice"                             # WAP Push Message Routing Service (see known issues)
    "lfsvc"                                        # Geolocation Service
    "MapsBroker"                                   # Downloaded Maps Manager
    "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
    "RemoteAccess"                                 # Routing and Remote Access
    "RemoteRegistry"                               # Remote Registry
    "SharedAccess"                                 # Internet Connection Sharing (ICS)
    "TrkWks"                                       # Distributed Link Tracking Client
    "WbioSrvc"                                     # Windows Biometric Service (required for Fingerprint reader / facial detection)
    "WlanSvc"                                      # WLAN AutoConfig
    "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
    "wscsvc"                                       # Windows Security Center Service
    "WSearch"                                      # Windows Search
    "XblAuthManager"                               # Xbox Live Auth Manager
    "XblGameSave"                                  # Xbox Live Game Save Service
    "XboxNetApiSvc"                                # Xbox Live Networking Service
    "XboxGipSvc"                                   #Disables Xbox Accessory Management Service
    "ndu"                                          # Windows Network Data Usage Monitor
    "WerSvc"                                       #disables windows error reporting
    "Spooler"                                      #Disables your printer
    "Fax"                                          #Disables fax
    "fhsvc"                                        #Disables fax histroy
    "gupdate"                                      #Disables google update
    "gupdatem"                                     #Disable another google update
    "stisvc"                                       #Disables Windows Image Acquisition (WIA)
    "AJRouter"                                     #Disables (needed for AllJoyn Router Service)
    "MSDTC"                                        # Disables Distributed Transaction Coordinator
    "dmwappushservice"                             #Device Management Wireless Application Protocol (WAP) Push message Routing Service
    "WpcMonSvc"                                    #Disables Parental Controls
    "PhoneSvc"                                     #Disables Phone Service(Manages the telephony state on the device)
    "PrintNotify"                                  #Disables Windows printer notifications and extentions
    "PcaSvc"                                       #Disables Program Compatibility Assistant Service
    "WPDBusEnum"                                   #Disables Portable Device Enumerator Service
    "LicenseManager"                               #Disable LicenseManager(Windows store may not work properly)
    "seclogon"                                     #Disables  Secondary Logon(disables other credentials only password will work)
    "SysMain"                                      #Disables sysmain
    "lmhosts"                                      #Disables TCP/IP NetBIOS Helper
    "wisvc"                                        #Disables Windows Insider program(Windows Insider will not work)
    "FontCache"                                    #Disables Windows font cache
    "RetailDemo"                                   #Disables RetailDemo whic is often used when showing your device
    "ALG"                                          # Disables Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
    #"BFE"                                         #Disables Base Filtering Engine (BFE) (is a service that manages firewall and Internet Protocol security)
    #"BrokerInfrastructure"                         #Disables Windows infrastructure service that controls which background tasks can run on the system.
    "SCardSvr"                                      #Disables Windows smart card
    "lfsvc"                                         #Disable Windows geolocation service  it can be use to track you
    "EntAppSvc"                                     #Disables enterprise application management.
    "BthAvctpSvc"                                   #Disables AVCTP service (if you use  Bluetooth Audio Device or Wireless Headphones. then don't disable this)
    "FrameServer"                                   #Disables Windows Camera Frame Server(this allows multiple clients to access video frames from camera devices.)
    "Browser"                                       #Disables computer browser
    "BthAvctpSvc"                                   #AVCTP service (This is Audio Video Control Transport Protocol service.)
    "BDESVC"                                        #Disables bitlocker
    "fhsvc"                                         # Disables File History Service  (Protects user files from accidental loss by copying them to a backup location.)
    "iphlpsvc"                                      #Disables ipv6 but most websites don't use ipv6 they use ipv4     
    "edgeupdate"                                    # Disables one of edge update service  
    "MicrosoftEdgeElevationService"                 # Disables one of edge  service 
    "edgeupdatem"                                   # disbales another one of update service (disables edgeupdatem)                          
    "SEMgrSvc"                                      #Disables Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
    #"PNRPsvc"                                      # Disables peer Name Resolution Protocol ( some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
    #"p2psvc"                                       # Disbales Peer Name Resolution Protocol(nables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)
    #"p2pimsvc"                                     # Disables Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly.Discord will still work)
    "PerfHost"                                      #Disables  remote users and 64-bit processes to query performance .



    # Services which cannot be disabled
    #"WdNisSvc"
)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}

$hyper = @(
    #hyper-v services
    "HvHost"                          
    "vmickvpexchange"
    "vmicguestinterface"
    "vmicshutdown"
    "vmicheartbeat"
    "vmicvmsession"
    "vmicrdv"
    "vmictimesync" 

)


foreach ($hyper in $hyper) {
    Write-Output "Trying to disable $hyper-v"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}

$hp = @(
     #hp services
    "HPAppHelperCap"
    "HPDiagsCap"
    "HPNetworkCap"
    "HPSysInfoCap"
    "HpTouchpointAnalyticsService"
)

 foreach ($hp in $hp) {
    Write-Output "Trying to disable $hp"
    Get-Service -Name $service | Set-Service -StartupType Disabled
}
