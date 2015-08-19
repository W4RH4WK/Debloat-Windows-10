#   Description:
# This script will rename the Cortana app folder so SeachUI.exe cannot be
# started.

taskkill.exe /F /IM "SearchUI.exe"

# try to rename folder while SearchUI is restarting
foreach ($_ in (0..15)) {
	if (Test-Path "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy") {
		mv "$env:windir\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" `
			"$env:windir\SystemApps\_Microsoft.Windows.Cortana_cw5n1h2txyewy" `
			-ErrorAction SilentlyContinue
	} else {
		break
	}
}
