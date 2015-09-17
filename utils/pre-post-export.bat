@echo off

echo "Start Exporting Pre State"
regedit.exe /e "%USERPROFILE%\Desktop\pre_hklm.reg" "HKEY_LOCAL_MACHINE"
regedit.exe /e "%USERPROFILE%\Desktop\pre_hkcu.reg" "HKEY_CURRENT_USER"
echo "Done Exporting Pre State"

pause

echo "Start Exporting Post State"
regedit.exe /e "%USERPROFILE%\Desktop\post_hklm.reg" "HKEY_LOCAL_MACHINE"
regedit.exe /e "%USERPROFILE%\Desktop\post_hkcu.reg" "HKEY_CURRENT_USER"
echo "Done Exporting Post State"
