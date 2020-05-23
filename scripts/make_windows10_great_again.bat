:: source: https://gist.github.com/IntergalacticApps/675339c2b805b4c9c6e9a442e0121b1d
@echo off
setlocal EnableDelayedExpansion

ver | find "10." > nul
if errorlevel 1 (
	echo Your Windows version is not Windows 10... yet. Brace yourself, Windows 10 is coming^^!
	pause
	exit
)

echo Make Windows 10 Great Again^^! Ultimate batch spyware and trash remover, v. 2.2.4.
echo Optimized for Anniversary Update.
pause

echo.
echo | set /p=Checking permissions... 
net session >nul 2>&1
if errorlevel 1 (
	echo Permission denied. Run this script as administrator.
	pause
	exit
) else (
	echo OK.
	timeout /t 1 > nul
)

reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v "ProductName" | find "LTSB" > nul
if not errorlevel 1 (
	set LTSB=1
)

if not defined LTSB (
	cls
	echo Deleting trash apps...
	powershell -Command "& {Get-AppxPackage -AllUsers | Remove-AppxPackage; Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online;}"
	takeown /f "%ProgramFiles%\WindowsApps" /r
	icacls "%ProgramFiles%\WindowsApps" /inheritance:e /grant "%UserName%:(OI)(CI)F" /T /C
	for /d %%i in ("%ProgramFiles%\WindowsApps\*") do (
		rd /s /q "%%i"
	)
	icacls "%ProgramFiles%\WindowsApps" /setowner "NT Service\TrustedInstaller"
	icacls "%ProgramFiles%\WindowsApps" /inheritance:r /remove "%UserName%"
)

cls
echo Deleting spyware firewall rules... 
powershell -Command "& {Get-NetFirewallRule | Where { $_.Group -like '*@{*' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.Group -eq 'DiagTrack' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.DisplayGroup -eq 'Delivery Optimization' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.DisplayGroup -like 'Windows Media Player Network Sharing Service*' } | Remove-NetFirewallRule;}"

cls
echo | set /p=Deleting OneDrive... 
taskkill /f /im OneDrive.exe > nul 2>&1
if exist %SystemRoot%\System32\OneDriveSetup.exe (
	start /wait %SystemRoot%\System32\OneDriveSetup.exe /uninstall
) else (
	start /wait %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
)
rd "%UserProfile%\OneDrive" /q /s > nul 2>&1
rd "%SystemDrive%\OneDriveTemp" /q /s > nul 2>&1
rd "%LocalAppData%\Microsoft\OneDrive" /q /s > nul 2>&1
rd "%ProgramData%\Microsoft OneDrive" /q /s > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d 1 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\OneDrive" /v "DisablePersonalSync" /t REG_DWORD /d 1 /f > nul
echo OK.

echo.
echo Deleting spyware/bloatware services...
set spy_services=^
	DiagTrack,dmwappushservice,diagnosticshub.standardcollector.service,DcpSvc,^
	WerSvc,PcaSvc,DoSvc,WMPNetworkSvc,XblAuthManager,XblGameSave,XboxNetApiSvc,^
	xboxgip,wlidsvc,lfsvc,NcbService,WbioSrvc,LicenseManager,OneSyncSvc,CDPSvc,^
	CDPUserSvc,MapsBroker,PhoneSvc,RetailDemo,WalletService
for %%i in (%spy_services%) do (
	sc query %%i > nul
	if not errorlevel 1060 (
		echo Current service: %%i
		sc stop %%i > nul
		sc delete %%i
		set spy_svc_found=1
	)
)
if not defined spy_svc_found (
	echo No spyware services found.
)

echo.
echo Disabling unsafe services...
set unsafe_services=^
	RemoteRegistry,TermService,TrkWks,DPS,^
	SensorDataService,SensorService,SensrSvc
for %%i in (%unsafe_services%) do (
	echo Current service: %%i
	sc stop %%i > nul
	sc config %%i start= disabled
)

echo.
echo Adding antispy firewall rules...
set spy_ips=^
	104.96.147.3,111.221.29.177,111.221.29.253,111.221.64.0-111.221.127.255,^
	131.253.40.37,134.170.115.60,134.170.165.248,134.170.185.70,131.253.40.109,^
	134.170.30.202,137.116.81.24,137.117.235.16,157.55.129.21,198.78.208.254,^
	157.55.130.0-157.55.130.255,157.55.235.0-157.55.235.255,66.119.144.189,^
	157.55.236.0-157.55.236.255,157.55.52.0-157.55.52.255,134.170.51.248,^
	157.55.56.0-157.55.56.255,157.56.106.189,157.56.121.89,157.56.124.87,^
	157.56.91.77,168.63.108.233,191.232.139.2-191.232.139.255,131.253.40.53,^
	191.232.80.62,191.237.208.126,195.138.255.0-195.138.255.255,94.245.121.251,^
	2.22.61.43,2.22.61.66,204.79.197.200,207.46.101.29,207.46.114.58,207.46.223.94,^
	207.68.166.254,212.30.134.204,212.30.134.205,213.199.179.0-213.199.179.255,^
	23.102.21.4,23.218.212.69,23.223.20.82,23.57.101.163,23.57.107.163,^
	23.57.107.27,23.99.10.11,64.4.23.0-64.4.23.255,64.4.54.22,64.4.54.32,^
	64.4.6.100,65.39.117.230,65.52.100.11,65.52.100.7,65.52.100.9,65.52.100.91,^
	65.52.100.92,65.52.100.93,65.52.100.94,65.52.108.29,65.52.108.33,65.55.108.23,^
	65.55.138.186,65.55.223.0-65.55.223.255,157.56.106.184,131.253.40.59,^
	65.55.252.63,65.55.252.71,65.55.252.92,65.55.252.93,65.55.29.238,65.55.39.10,^
	77.67.29.176,204.79.197.203,111.221.29.254,128.63.2.53,131.253.14.153,^
	134.170.188.248,134.170.52.151,157.56.149.250,207.46.114.61,64.4.54.153,^
	157.56.57.5,157.56.74.250,168.61.24.141,168.62.187.13,191.232.140.76,^
	64.4.54.253,64.4.54.254,65.52.108.153,65.52.108.154,65.55.44.108,65.52.161.64,^
	65.55.130.50,65.55.138.110,65.55.176.90,65.55.252.43,65.55.44.109,^
	65.55.83.120,66.119.147.131,194.44.4.200,194.44.4.208,8.254.209.254,^
	157.56.77.139,134.170.58.121,207.46.194.14,207.46.194.33,13.107.3.128,^
	134.170.53.30,134.170.51.190,131.107.113.238,157.56.96.58,23.67.60.73,^
	104.82.22.249,207.46.194.25,173.194.113.220,173.194.113.219,216.58.209.166,^
	157.56.91.82,157.56.23.91,104.82.14.146,207.123.56.252,185.13.160.61,^
	94.245.121.253,65.52.108.92,207.46.7.252,23.74.8.99,23.74.8.80,65.52.108.103,^
	23.9.123.27,23.74.9.198,23.74.9.217,23.96.212.225,23.101.115.193,^
	23.101.156.198,23.101.187.68,23.102.17.214,23.193.225.197,23.193.230.88,^
	23.193.236.70,23.193.238.90,23.193.251.132,23.210.5.16,23.210.48.42,^
	23.210.63.75,23.217.138.11,23.217.138.18,23.217.138.25,23.217.138.43,^
	23.217.138.90,23.217.138.97,23.217.138.122,40.117.145.132,65.52.108.94,^
	65.52.108.252,65.52.236.160,65.55.113.13,65.55.252.190,65.52.108.27,^
	94.245.121.254,104.73.92.149,104.73.138.217,104.73.143.160,104.73.153.9,^
	104.73.160.16,104.73.160.51,104.73.160.58,104.91.166.82,104.91.188.21,^
	104.208.28.54,134.170.51.246,134.170.179.87,137.116.74.190,157.56.77.138,^
	157.56.96.123,157.56.144.215,157.56.144.216,198.41.214.183,198.41.214.184,^
	198.41.214.186,198.41.214.187,198.41.215.182,198.41.215.185,198.41.215.186
for %%i in (%spy_ips%) do (
	netsh advfirewall firewall show rule %%i_BLOCK > nul
		if errorlevel 1 (
			echo | set /p=%%i_BLOCK 
			route -p ADD %%i MASK 255.255.255.255 0.0.0.0 > nul 2>&1
			netsh advfirewall firewall add rule name="%%i_BLOCK" dir=out interface=any action=block remoteip=%%i > nul
			set frw_rule_added=1
			echo [OK]
		)
)
set svchost=%SystemRoot%\System32\svchost.exe
set svchost_rules=^
	"VeriSign Global Registry Services;199.7.48.0-199.7.63.255,199.16.80.0-199.16.95.255"^
	"Microsoft Limited;94.245.64.0-94.245.127.255"^
	"Microsoft Internet Data Center;213.199.160.0-213.199.191.255"^
	"Akamai Technologies;92.122.212.0-92.122.219.255,92.123.96.0-92.123.111.255,95.100.0.0-95.100.15.255,23.32.0.0-23.67.255.255"
for %%i in (%svchost_rules%) do (
	for /f "tokens=1,2 delims=;" %%a in (%%i) do (
		netsh advfirewall firewall show rule "%%a SVCHOST_BLOCK" > nul
		if errorlevel 1 (
			echo | set /p=%%a SVCHOST_BLOCK 
			netsh advfirewall firewall add rule name="%%a SVCHOST_BLOCK" dir=out interface=any action=block program=%svchost% remoteip=%%b > nul
			set frw_rule_added=1
			echo [OK]
		)
	)
)
set spy_apps=^
	"Program Files\Common Files\microsoft shared\OFFICE16\OLicenseHeartbeat.exe"^
	"Program Files\Microsoft Office\Office16\EXCEL.EXE"^
	"Program Files\Microsoft Office\Office16\MSACCESS.EXE"^
	"Program Files\Microsoft Office\Office16\msoia.exe"^
	"Program Files\Microsoft Office\Office16\MSOSYNC.EXE"^
	"Program Files\Microsoft Office\Office16\MSOUC.EXE"^
	"Program Files\Microsoft Office\Office16\MSPUB.EXE"^
	"Program Files\Microsoft Office\Office16\POWERPNT.EXE"^
	"Program Files\Microsoft Office\Office16\SETLANG.EXE"^
	"Program Files\Microsoft Office\Office16\WINWORD.EXE"^
	"Program Files\Microsoft Office\root\Office16\EXCEL.EXE"^
	"Program Files\Microsoft Office\root\Office16\MSACCESS.EXE"^
	"Program Files\Microsoft Office\root\Office16\msoia.exe"^
	"Program Files\Microsoft Office\root\Office16\MSOSYNC.EXE"^
	"Program Files\Microsoft Office\root\Office16\MSOUC.EXE"^
	"Program Files\Microsoft Office\root\Office16\MSPUB.EXE"^
	"Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"^
	"Program Files\Microsoft Office\root\Office16\SETLANG.EXE"^
	"Program Files\Microsoft Office\root\Office16\WINWORD.EXE"^
	"Program Files (x86)\Common Files\Microsoft Shared\OFFICE16\OLicenseHeartbeat.exe"^
	"Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\MSACCESS.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\msoia.exe"^
	"Program Files (x86)\Microsoft Office\Office16\MSOSYNC.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\MSOUC.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\MSPUB.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\POWERPNT.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\SETLANG.EXE"^
	"Program Files (x86)\Microsoft Office\Office16\WINWORD.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\EXCEL.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\MSACCESS.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\msoia.exe"^
	"Program Files (x86)\Microsoft Office\root\Office16\MSOSYNC.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\MSOUC.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\MSPUB.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\POWERPNT.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\SETLANG.EXE"^
	"Program Files (x86)\Microsoft Office\root\Office16\WINWORD.EXE"^
	"Windows\explorer.exe"^
	"Windows\ImmersiveControlPanel\SystemSettings.exe"^
	"Windows\System32\backgroundTaskHost.exe"^
	"Windows\System32\BackgroundTransferHost.exe"^
	"Windows\System32\browser_broker.exe"^
	"Windows\System32\CompatTelRunner.exe"^
	"Windows\System32\dmclient.exe"^
	"Windows\System32\InstallAgentUserBroker.exe"^
	"Windows\System32\lsass.exe"^
	"Windows\System32\msfeedssync.exe"^
	"Windows\System32\rundll32.exe"^
	"Windows\System32\SettingSyncHost.exe"^
	"Windows\System32\SIHClient.exe"^
	"Windows\System32\smartscreen.exe"^
	"Windows\System32\taskhostw.exe"^
	"Windows\System32\wbem\WmiPrvSE.exe"^
	"Windows\System32\WerFault.exe"^
	"Windows\System32\wermgr.exe"^
	"Windows\System32\wsqmcons.exe"^
	"Windows\System32\WWAHost.exe"^
	"Windows\SystemApps\ContactSupport_cw5n1h2txyewy\ContactSupport.exe"^
	"Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"^
	"Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe"^
	"Windows\SysWOW64\backgroundTaskHost.exe"^
	"Windows\SysWOW64\BackgroundTransferHost.exe"^
	"Windows\SysWOW64\InstallAgentUserBroker.exe"^
	"Windows\SysWOW64\msfeedssync.exe"^
	"Windows\SysWOW64\rundll32.exe"^
	"Windows\SysWOW64\SettingSyncHost.exe"^
	"Windows\SysWOW64\wbem\WmiPrvSE.exe"^
	"Windows\SysWOW64\WerFault.exe"^
	"Windows\SysWOW64\wermgr.exe"^
	"Windows\SysWOW64\WWAHost.exe"
for %%i in (%spy_apps%) do (
	set item=%%i
	set file_path="%SystemDrive%\!item:~1!
	if exist !file_path! (
		echo !file_path! | find "SysWOW64" > nul
		if errorlevel 1 (
			set rule_name=%%~nxi_BLOCK
		) else (
			set rule_name=%%~nxi-SysWOW64_BLOCK
		)
		netsh advfirewall firewall show rule !rule_name! > nul
		if errorlevel 1 (
			echo | set /p=!rule_name! 
			netsh advfirewall firewall add rule name=!rule_name! dir=out interface=any action=block program=!file_path! > nul
			set frw_rule_added=1
			echo [OK]
		)
	)
)
set spy_svc=WSearch
netsh advfirewall firewall show rule %spy_svc%_BLOCK > nul
if errorlevel 1 (
	echo | set /p=%spy_svc%_BLOCK 
	netsh advfirewall firewall add rule name="%spy_svc%_BLOCK" dir=out interface=any action=block service=%spy_svc% > nul
	set frw_rule_added=1
	echo [OK]
)
if not defined frw_rule_added (
	echo Antispy rules already present.
)

echo.
echo Blocking spyware domains...
set spy_domains=^
	nullroute,^
	statsfe2.update.microsoft.com.akadns.net,fe2.update.microsoft.com.akadns.net,^
	survey.watson.microsoft.com,watson.microsoft.com,^
	watson.ppe.telemetry.microsoft.com,vortex.data.microsoft.com,^
	vortex-win.data.microsoft.com,telecommand.telemetry.microsoft.com,^
	telecommand.telemetry.microsoft.com.nsatc.net,oca.telemetry.microsoft.com,^
	sqm.telemetry.microsoft.com,sqm.telemetry.microsoft.com.nsatc.net,^
	watson.telemetry.microsoft.com,watson.telemetry.microsoft.com.nsatc.net,^
	redir.metaservices.microsoft.com,choice.microsoft.com,^
	choice.microsoft.com.nsatc.net,wes.df.telemetry.microsoft.com,^
	services.wes.df.telemetry.microsoft.com,sqm.df.telemetry.microsoft.com,^
	telemetry.microsoft.com,telemetry.appex.bing.net,telemetry.urs.microsoft.com,^
	settings-sandbox.data.microsoft.com,watson.live.com,statsfe2.ws.microsoft.com,^
	corpext.msitadfs.glbdns2.microsoft.com,www.windowssearch.com,ssw.live.com,^
	sls.update.microsoft.com.akadns.net,i1.services.social.microsoft.com,^
	diagnostics.support.microsoft.com,corp.sts.microsoft.com,^
	statsfe1.ws.microsoft.com,feedback.windows.com,feedback.microsoft-hohm.com,^
	feedback.search.microsoft.com,rad.msn.com,preview.msn.com,^
	df.telemetry.microsoft.com,reports.wes.df.telemetry.microsoft.com,^
	vortex-sandbox.data.microsoft.com,settings.data.microsoft.com,^
	oca.telemetry.microsoft.com.nsatc.net,pre.footprintpredict.com,^
	spynet2.microsoft.com,spynetalt.microsoft.com,win10.ipv6.microsoft.com,^
	fe3.delivery.dsp.mp.microsoft.com.nsatc.net,cache.datamart.windows.com,^
	db3wns2011111.wns.windows.com,settings-win.data.microsoft.com,^
	v10.vortex-win.data.microsoft.com,apps.skype.com,^
	g.msn.com,bat.r.msn.com,client-s.gateway.messenger.live.com,^
	arc.msn.com,rpt.msn.com,bn1303.settings.live.net,client.wns.windows.com,^
	ieonlinews.microsoft.com,inprod.support.services.microsoft.com,^
	geover-prod.do.dsp.mp.microsoft.com,geo-prod.do.dsp.mp.microsoft.com,^
	kv201-prod.do.dsp.mp.microsoft.com,cp201-prod.do.dsp.mp.microsoft.com,^
	disc201-prod.do.dsp.mp.microsoft.com,array201-prod.do.dsp.mp.microsoft.com,^
	array202-prod.do.dsp.mp.microsoft.com,array203-prod.do.dsp.mp.microsoft.com,^
	array204-prod.do.dsp.mp.microsoft.com,tsfe.trafficshaping.dsp.mp.microsoft.com,^
	dl.delivery.mp.microsoft.com,tlu.dl.delivery.mp.microsoft.com,^
	statsfe1-df.ws.microsoft.com,statsfe2-df.ws.microsoft.com,^
	public-family.api.account.microsoft.com,dub407-m.hotmail.com,^
	www.bing.com,c.bing.com,g.bing.com,appex.bing.com,^
	urs.microsoft.com,c.urs.microsoft.com,t.urs.microsoft.com,activity.windows.com,^
	uif.microsoft.com,iecvlist.microsoft.com,ieonline.microsoft.com,c.microsoft.com,^
	nexus.officeapps.live.com,nexusrules.officeapps.live.com,c1.microsoft.com,^
	c.s-microsoft.com,apprep.smartscreen.microsoft.com,otf.msn.com,c.msn.com,^
	rr.office.microsoft.com,web.vortex.data.microsoft.com,ocsa.office.microsoft.com,^
	ocos-office365-s2s.msedge.net,odc.officeapps.live.com,uci.officeapps.live.com,^
	roaming.officeapps.live.com,urs.smartscreen.microsoft.com
set hosts=%SystemRoot%\System32\drivers\etc\hosts
for %%i in (%spy_domains%) do (
	find /c " %%i" %hosts% > nul
	if errorlevel 1 (
		echo %%i
		echo 0.0.0.0 %%i>>%hosts%
		set hosts_added=1
	)
)
if not defined hosts_added (
	echo Spyware domains already blocked.
) else (
	echo.
	echo | set /p=Flushing DNS cache 
	ipconfig /flushdns > nul
	echo [OK]
)

echo.
echo Adding registry tweaks...

echo | set /p=Disable telemetry 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\dmwappushsvc" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t REG_DWORD /d 4 /f > nul
echo [OK]

echo | set /p=Disable Windows Customer Experience Improvement Program 
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient" /v "CorporateSQMURL" /t REG_SZ /d "0.0.0.0" /f > nul
echo [OK]

echo | set /p=Disable Application Telemetry 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable Inventory Collector 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Steps Recorder 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Advertising ID 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable keylogger 
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable browser access to local language 
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable SmartScreen 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f > nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable Cortana and web search 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d 3 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable Wi-Fi Sense 
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable biometrics 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d 4 /f > nul
echo [OK]

echo | set /p=Disable location access and sensors 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable sync 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d 5 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable device access for Universal Apps 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9D9E0118-1807-4F2E-96E4-2CE57142E196}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{B19F89AF-E3EB-444B-8DEA-202575A71599}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E83AF229-8640-4D18-A213-E22675EBB2C3}" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v "Value" /t REG_SZ /d "Deny" /f > nul
if not defined LTSB (
	set edge_path=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\S-1-15-2-3624051433-2125758914-1423191267-1740899205-1073925389-3782572162-737981194
	reg add !edge_path!\{2EEF81BE-33FA-4800-9670-1CD474972C3F} /v "Value" /t REG_SZ /d "Deny" /f > nul
	reg add !edge_path!\{E5323777-F976-4f5b-9B55-B94699C46E44} /v "Value" /t REG_SZ /d "Deny" /f > nul
)
set shell_exp_path=HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\S-1-15-2-155514346-2573954481-755741238-1654018636-1233331829-3075935687-2861478708
reg add %shell_exp_path%\{7D7E8402-7C54-4821-A34E-AEEFD62DED93} /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCalendar" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessContacts" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessEmail" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMessaging" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessNotifications" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessPhone" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessRadios" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" /v "UserAuthPolicy" /t REG_DWORD /d 0 /f > nul
echo [OK]

if not defined LTSB (
	echo | set /p=Disable background access for Universal Apps 
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.PPIProjection_cw5n1h2txyewy" /v "Disabled" /t REG_DWORD /d 1 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.PPIProjection_cw5n1h2txyewy" /v "DisabledByUser" /t REG_DWORD /d 1 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Windows.ContactSupport_cw5n1h2txyewy" /v "Disabled" /t REG_DWORD /d 1 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Windows.ContactSupport_cw5n1h2txyewy" /v "DisabledByUser" /t REG_DWORD /d 1 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /v "Disabled" /t REG_DWORD /d 1 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" /v "DisabledByUser" /t REG_DWORD /d 1 /f > nul
	echo [OK]
)

echo | set /p=Disable protected trash services 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d 4 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d 4 /f > nul
echo [OK]

echo | set /p=Disable Windows Defender 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisDrv" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d 4 /f > nul 2>&1
regsvr32 /s /u "%ProgramFiles%\Windows Defender\shellext.dll"
taskkill /f /im MSASCuiL.exe > nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "WindowsDefender" /f > nul 2>&1
echo [OK]

if not defined LTSB (
	echo | set /p=Disable Windows Store 
	reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableStoreApps" /t REG_DWORD /d 1 /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 1 /f > nul
	echo [OK]
)

echo | set /p=Disable Delivery Optimization 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d 4 /f > nul
echo [OK]

echo | set /p=Disable Program Compatibility Assistant 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d 4 /f > nul
echo [OK]

echo | set /p=Disable Windows Error Reporting 
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Windows Tips 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Windows Consumer Features (App Suggestions on Start) 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f > nul
echo [OK]

if not defined LTSB (
	echo | set /p=Disable ads on lock screen 
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "LockImageFlags" /t REG_DWORD /d 0 /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "CreativeId" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "PortraitAssetPath" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "LandscapeAssetPath" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "DescriptionText" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "ActionText" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "ActionUri" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "PlacementId" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "ClickthroughToken" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "ImpressionToken" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "HotspotImageFolderPath" /t REG_SZ /d "" /f > nul
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /v "CreativeJson" /t REG_SZ /d "" /f > nul
	echo [OK]
)

echo | set /p=Disable File History 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\FileHistory" /v "Disabled" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Active Help 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable loggers 
reg add "HKLM\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable Windows Feedback 
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Microsoft Help feedback 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable feedback on write 
reg add "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable lock screen camera 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable password reveal button 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Windows Insider Program 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable DRM features 
reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Office 2016 telemetry 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\osm" /v "Enablelogging" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\osm" /v "EnableUpload" /t REG_DWORD /d 0 /f > nul
echo [OK]

if not defined LTSB (
	echo | set /p=Disable Adobe Flash Player in Microsoft Edge 
	reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Addons" /v "FlashPlayerEnabled" /t REG_DWORD /d 0 /f > nul
	echo [OK]
)

echo | set /p=Disable Game DVR 
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable Live Tiles 
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable AutoPlay and AutoRun 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Disable Remote Assistance 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Disable administrative shares 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Do not send Windows Media Player statistics 
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Remove 3D Builder from context menu 
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.bmp\Shell\T3D Print" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\Shell\T3D Print" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\T3D Print" /f > nul 2>&1
echo [OK]

echo | set /p=Set default PhotoViewer 
reg add "HKCU\SOFTWARE\Classes\.ico" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.tiff" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.bmp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.png" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.gif" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.jpeg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
reg add "HKCU\SOFTWARE\Classes\.jpg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f > nul
echo [OK]

echo | set /p=Turn off "You have new apps that can open this type of file" alert 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d 1 /f > nul
echo [OK]

if not defined LTSB (
	echo | set /p=Turn off "Look For An App In The Store" option 
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d 1 /f > nul
	echo [OK]
)

echo | set /p=Open File Explorer to This PC instead of Quick Access 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Do not show recently used files in Quick Access 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Do not show frequently used folders in Quick Access 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Show hidden files, folders and drives in File Explorer 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Show file extensions in File Explorer 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Launch folder windows in a separate process 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Auto-end non responsive tasks 
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f > nul
echo [OK]

echo | set /p=Maximize wallpaper quality 
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d 100 /f > nul
echo [OK]

echo | set /p=Set icon cache size to 4096 KB 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "4096" /f > nul
echo [OK]

echo | set /p=Add Recycle Bin to Navigation Pane 
reg add "HKCU\SOFTWARE\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Restore Classic Context Menu in Explorer 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d 0 /f > nul
echo [OK]

echo | set /p=Set "Do this for all current items" checkbox by default in the file operation conflict dialog 
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "ConfirmationCheckBoxDoForAll" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo | set /p=Enable NTFS long paths 
reg add "HKLM\SYSTEM\CurrentControlSet\Policies" /v "LongPathsEnabled" /t REG_DWORD /d 1 /f > nul
echo [OK]

echo.
echo | set /p=Restarting Explorer... 
taskkill /f /im explorer.exe >nul & explorer.exe
schtasks /delete /tn "CreateExplorerShellUnelevatedTask" /f > nul
echo OK.

echo.
echo Deleting spyware tasks...
set spy_tasks=^
	"Microsoft\Office\Office 15 Subscription Heartbeat"^
	"Microsoft\Office\OfficeTelemetryAgentFallBack2016"^
	"Microsoft\Office\OfficeTelemetryAgentLogOn2016"^
	"Microsoft\Windows\AppID\SmartScreenSpecific"^
	"Microsoft\Windows\Application Experience\AitAgent"^
	"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"^
	"Microsoft\Windows\Application Experience\ProgramDataUpdater"^
	"Microsoft\Windows\Application Experience\StartupAppTask"^
	"Microsoft\Windows\Autochk\Proxy"^
	"Microsoft\Windows\Clip\License Validation"^
	"Microsoft\Windows\CloudExperienceHost\CreateObjectTask"^
	"Microsoft\Windows\Customer Experience Improvement Program\BthSQM"^
	"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"^
	"Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"^
	"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"^
	"Microsoft\Windows\Device Information\Device"^
	"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"^
	"Microsoft\Windows\Feedback\Siuf\DmClient"^
	"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"^
	"Microsoft\Windows\License Manager\TempSignedLicenseExchange"^
	"Microsoft\Windows\Location\Notifications"^
	"Microsoft\Windows\Location\WindowsActionDialog"^
	"Microsoft\Windows\Maps\MapsToastTask"^
	"Microsoft\Windows\Maps\MapsUpdateTask"^
	"Microsoft\Windows\Media Center\ActivateWindowsSearch"^
	"Microsoft\Windows\Media Center\ConfigureInternetTimeService"^
	"Microsoft\Windows\Media Center\DispatchRecoveryTasks"^
	"Microsoft\Windows\Media Center\ehDRMInit"^
	"Microsoft\Windows\Media Center\InstallPlayReady"^
	"Microsoft\Windows\Media Center\mcupdate"^
	"Microsoft\Windows\Media Center\MediaCenterRecoveryTask"^
	"Microsoft\Windows\Media Center\ObjectStoreRecoveryTask"^
	"Microsoft\Windows\Media Center\OCURActivate"^
	"Microsoft\Windows\Media Center\OCURDiscovery"^
	"Microsoft\Windows\Media Center\PBDADiscovery"^
	"Microsoft\Windows\Media Center\PBDADiscoveryW1"^
	"Microsoft\Windows\Media Center\PBDADiscoveryW2"^
	"Microsoft\Windows\Media Center\PvrRecoveryTask"^
	"Microsoft\Windows\Media Center\PvrScheduleTask"^
	"Microsoft\Windows\Media Center\RegisterSearch"^
	"Microsoft\Windows\Media Center\ReindexSearchRoot"^
	"Microsoft\Windows\Media Center\SqlLiteRecoveryTask"^
	"Microsoft\Windows\Media Center\UpdateRecordPath"^
	"Microsoft\Windows\Maintenance\WinSAT"^
	"Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"^
	"Microsoft\Windows\RetailDemo\CleanupOfflineContent"^
	"Microsoft\Windows\SettingSync\BackgroundUploadTask"^
	"Microsoft\Windows\SettingSync\BackupTask"^
	"Microsoft\Windows\SettingSync\NetworkStateChangeTask"^
	"Microsoft\Windows\Shell\FamilySafetyMonitor"^
	"Microsoft\Windows\Shell\FamilySafetyMonitorToastTask"^
	"Microsoft\Windows\Shell\FamilySafetyRefresh"^
	"Microsoft\Windows\Shell\FamilySafetyRefreshTask"^
	"Microsoft\Windows\Speech\SpeechModelDownloadTask"^
	"Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"^
	"Microsoft\Windows\Windows Defender\Windows Defender Cleanup"^
	"Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"^
	"Microsoft\Windows\Windows Defender\Windows Defender Verification"^
	"Microsoft\Windows\Windows Error Reporting\QueueReporting"^
	"Microsoft\Windows\WindowsUpdate\Automatic App Update"^
	"Microsoft\Windows\WindowsUpdate\sih"^
	"Microsoft\Windows\WindowsUpdate\sihboot"^
	"Microsoft\Windows\WS\License Validation"^
	"Microsoft\Windows\WS\WSTask"^
	"Microsoft\XblGameSave\XblGameSaveTask"^
	"Microsoft\XblGameSave\XblGameSaveTaskLogon"
set tasks_dir=%SystemRoot%\System32\Tasks
for %%i in (%spy_tasks%) do (
	schtasks /query /tn %%i > nul 2>&1
	if not errorlevel 1 (
		echo | set /p=%%i
		schtasks /delete /tn %%i /f > nul
		set item=%%i
		set dir_path="%tasks_dir%\!item:~1!
		mkdir !dir_path!
		icacls !dir_path! /deny "Everyone:(OI)(CI)W" > nul
		set spy_task_deleted=1
		echo  [OK]
	)
)
if not defined spy_task_deleted (
	echo Spyware tasks already deleted.
)

set update_orchestrator_dir=%tasks_dir%\Microsoft\Windows\UpdateOrchestrator
if not exist %update_orchestrator_dir%\Reboot\ (
	echo.
	echo | set /p=Prevent Windows 10 reboots after installing updates... 
	schtasks /delete /tn "Microsoft\Windows\UpdateOrchestrator\Reboot" /f > nul 2>&1
	mkdir %update_orchestrator_dir%\Reboot
	icacls %update_orchestrator_dir%\Reboot /deny "Everyone:(OI)(CI)W" > nul
	echo OK.
)

echo.
echo Finished.
pause
