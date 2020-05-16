@echo off
openfiles.exe 1>nul 2>&1
if errorlevel 1 (
    echo You are not administrator! Right Click file select run as admin!
    pause 1>nul 2>&1
    EXIT 1
)

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM --- search and destroy specific updates
echo uninstalling updates, be patient...
echo Delete KB971033 (license validation)
start "title" /b /wait wusa.exe /kb:971033 /uninstall /quiet /norestart
echo  - next
echo Delete KB2902907 (Microsoft Security Essentials)
start "title" /b /wait wusa.exe /kb:2902907 /uninstall /quiet /norestart
echo  - next
echo Delete KB2952664 (Get Windows 10 assistant)
start "title" /b /wait wusa.exe /kb:2952664 /uninstall /quiet /norestart
echo  - next
echo Delete KB2976978 (update for windows 8.1 and windows 8)
start "title" /b /wait wusa.exe /kb:2976978 /uninstall /quiet /norestart
echo  - next
echo Delete KB2977759 (update for windows 7 rtm)
start "title" /b /wait wusa.exe /kb:2977759 /uninstall /quiet /norestart
echo  - next
echo Delete KB2990214 (Get Windows 10 for Win7)
start "title" /b /wait wusa.exe /kb:2990214 /uninstall /quiet /norestart
echo  - next
echo Delete KB3012973 (Upgrade to Windows 10 Pro)
start "title" /b /wait wusa.exe /kb:3012973 /uninstall /quiet /norestart
echo  - next
echo Delete KB3014460 (Upgrade for windows insider preview / upgrade to windows 10)
start "title" /b /wait wusa.exe /kb:3014460 /uninstall /quiet /norestart
echo  - next
echo Delete KB3015249 (Upgrade that adds telemetry points to consent.exe in Windows 8.1 and Windows 7)
start "title" /b /wait wusa.exe /kb:3015249 /uninstall /quiet /norestart
echo  - next
echo Delete KB3021917 (update to Windows 7 SP1 for performance improvements)
start "title" /b /wait wusa.exe /kb:3021917 /uninstall /quiet /norestart
echo  - next
echo Delete KB3022345 (telemetry)
start "title" /b /wait wusa.exe /kb:3022345 /uninstall /quiet /norestart
echo  - next
echo Delete KB3035583 (GWX Update installs Get Windows 10 app in Windows 8.1 and Windows 7 SP1)
start "title" /b /wait wusa.exe /kb:3035583 /uninstall /quiet /norestart
echo  - next
echo Delete KB3044374 (Get Windows 10 for Win8.1)
start "title" /b /wait wusa.exe /kb:3044374 /uninstall /quiet /norestart
echo  - next
echo Delete KB3050265 (update for Windows Update on Win7)
start "title" /b /wait wusa.exe /kb:3050265 /uninstall /quiet /norestart
echo  - next
echo Delete KB3050267 (update for windows update client for windows 8.1 june 2015)
start "title" /b /wait wusa.exe /kb:3050267 /uninstall /quiet /norestart
echo  - next
echo Delete KB3065987 (update for Windows Update on Win7/Server 2008R2)
start "title" /b /wait wusa.exe /kb:3065987 /uninstall /quiet /norestart
echo  - next
echo Delete KB3068708 (telemetry)
start "title" /b /wait wusa.exe /kb:3068708 /uninstall /quiet /norestart
echo  - next
echo Delete KB3075249 (telemetry for Win7/8.1)
start "title" /b /wait wusa.exe /kb:3075249 /uninstall /quiet /norestart
echo  - next
echo Delete KB3075851 (update for Windows Update on Win7/Server 2008R2)
start "title" /b /wait wusa.exe /kb:3075851 /uninstall /quiet /norestart
echo  - next
echo Delete KB3075853 (update for Windows Update on Win8.1/Server 2012R2)
start "title" /b /wait wusa.exe /kb:3075853 /uninstall /quiet /norestart
echo  - next
echo Delete KB3080149 (Telemetry)
start "title" /b /wait wusa.exe /kb:3080149 /uninstall /quiet /norestart
echo  - next
echo Delete KB3112336 (monitor quality of upgrade experience)
start "title" /b /wait wusa.exe /kb:3112336 /uninstall /quiet /norestart
echo  - done.
timeout 5

REM --- uninstall all kb updates
echo Uninstalling updates, be patient...
for %%f in ( %~dp0*.list ) do (
    for /F "tokens=1,2,*" %%k in (%%~f) do (
        if "%%~l" gtr "%~1" (
            set _LIST=!_LIST! %%~k
            < nul: set /P _=Removing KB%%~k "%%~m"
            start "%%~k" /WAIT wusa.exe /kb:%%~k /uninstall /quiet /norestart
            if errorlevel 1 (
                echo  - not found.
            ) ELSE (
                echo  - done.
            )
        )
    )
)
echo.

REM --- Hide updates
echo Hiding updates, may take a while be patient...

cscript.exe /NoLogo "%~dp0HideWindowsUpdates.vbs" %_LIST%
echo  - done.
echo.

REM --- Disable tasks
echo Disabling tasks. Depending on Windows version this may give errors, this is normal...

schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ActivateWindowsSearch" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ConfigureInternetTimeService" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\DispatchRecoveryTasks" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ehDRMInit" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\InstallPlayReady" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\mcupdate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\MediaCenterRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ObjectStoreRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\OCURActivate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\OCURDiscovery" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscovery" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscoveryW1" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PBDADiscoveryW2" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PvrRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\PvrScheduleTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\RegisterSearch" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\ReindexSearchRoot" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\SqlLiteRecoveryTask" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Media Center\UpdateRecordPath" /DISABLE
echo - done.
echo.

REM --- Kill services
< NUL: SET /P =Killing Diagtrack-service (if it still exists)...
sc stop Diagtrack > NUL:
sc delete Diagtrack > NUL:
echo  - done.

echo.
echo Done. Manually Reboot for changes to take effect.
REM shutdown -r
PAUSE