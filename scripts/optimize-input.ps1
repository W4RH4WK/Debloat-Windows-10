#   Description
# This script will apply MarkC's mouse acceleration fix (for 100% DPI) and
# disable some accessibility features regarding keyboard input.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\reg-helper.psm1

echo "Apply MarkC's mouse acceleration fix"
Import-Registry(@"
[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSensitivity"="10"
"SmoothMouseXCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	C0,CC,0C,00,00,00,00,00,\
	80,99,19,00,00,00,00,00,\
	40,66,26,00,00,00,00,00,\
	00,33,33,00,00,00,00,00
"SmoothMouseYCurve"=hex:\
	00,00,00,00,00,00,00,00,\
	00,00,38,00,00,00,00,00,\
	00,00,70,00,00,00,00,00,\
	00,00,A8,00,00,00,00,00,\
	00,00,E0,00,00,00,00,00

[HKEY_USERS\.DEFAULT\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"
"@)

echo "Disable easy access keyboard stuff"
Import-Registry(@"
[HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
"Flags"="378"

[HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys]
"Flags"="58"
"@)
