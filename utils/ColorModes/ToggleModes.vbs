On Error Resume Next
Const HKEY_CURRENT_USER = &H80000001
strKeyName = HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
strValueName = AppsUseLightTheme

Set objRegistry = GetObject("winmgmts:\\.\root\default:StdRegProv")
objRegistry.GetStringValue HKEY_LOCAL_MACHINE, strKeyName, strValueName, strValue

Set WshShell = Wscript.CreateObject("Wscript.Shell")

If strValue = "0" Then
    WshShell.run "cmd /c regedit %cd%\DarkMode.reg",0,True
Else
    WshShell.run "cmd /c regedit %cd%\LightMode.reg",0,True

End If


Set objScriptShell = CreateObject("Wscript.Shell")
objScriptShell.Run "taskkill /f /im explorer.exe", 0, true
WScript.Sleep 1000

objScriptShell.Run "explorer"