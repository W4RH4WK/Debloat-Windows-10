#   Description
# This script will apply MarkC's mouse acceleration fix (for 100% DPI) and
# disable some accessibility features regarding keyboard input.  Additional
# some UI elements will be changed.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

echo "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

mkdir -Force "HKCR:\Applications\photoviewer.dll\shell\open\command"
mkdir -Force "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget"

mkdir -Force "HKCR:\Applications\photoviewer.dll\shell\print\command"
mkdir -Force "HKCR:\Applications\photoviewer.dll\shell\print\DropTarget"

cmd /c regsvr32 /s "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll"

echo "Setting default Photo Viewer to Old Windows Photo Viewer"
sp "HKCR:\Applications\photoviewer.dll\shell\open" "MuiVerb" "@photoviewer.dll,-3043"

sp "HKCR:\Applications\photoviewer.dll\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e

sp "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

sp "HKCR:\Applications\photoviewer.dll\shell\print\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e

sp "HKCR:\Applications\photoviewer.dll\shell\print\DropTarget]" "Clsid" "{60fd46de-f830-4894-a628-6fa81bc0190d}"

echo "Set default association for Photo Viewer"
# Dism /Online /Import-DefaultAppAssociations:.\AppAssoc.xml

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Bitmap\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.Bitmap" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Bitmap" "FriendlyTypeName" "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3056" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-70"
sp "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.JFIF\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.JFIF" "EditFlags" 0x10000 -t d
sp "HKCR:\PhotoViewer.FileAssoc.JFIF" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.JFIF" "FriendlyTypeName" "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055" -t e
sp "HKCR:\PhotoViewer.FileAssoc.JFIF\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-72"
sp "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open" "MuiVerb" "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" -t e
sp "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Jpeg\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg" "EditFlags" 0x10000 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg" "FriendlyTypeName" "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-72"
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open" "MuiVerb" "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Gif\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.Gif" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Gif" "FriendlyTypeName" "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Gif\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-83"
sp "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Png\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.Png" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Png" "FriendlyTypeName" "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Png\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-71"
sp "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Wdp\DefaultIcon"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\command"
mkdir -Force "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget"
sp "HKCR:\PhotoViewer.FileAssoc.Wdp" "EditFlags" 0x10000 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Wdp" "ImageOptionFlags" 1 -t d
sp "HKCR:\PhotoViewer.FileAssoc.Wdp\DefaultIcon" '(default)' "%SystemRoot%\System32\imageres.dll,-400"
sp "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open" "MuiVerb" "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\command" '(default)' "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1" -t e
sp "HKCR:\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" "Clsid" "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

mkdir -Force "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" "ApplicationDescription" "@%ProgramFiles%\\Windows Photo Viewer\\photoviewer.dll,-3069"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" "ApplicationName" "@%ProgramFiles%\\Windows Photo Viewer\\photoviewer.dll,-3009"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".jpg" "PhotoViewer.FileAssoc.Jpeg"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".wdp" "PhotoViewer.FileAssoc.Wdp"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".jfif" "PhotoViewer.FileAssoc.JFIF"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".dib" "PhotoViewer.FileAssoc.Bitmap"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".png" "PhotoViewer.FileAssoc.Png"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".jxr" "PhotoViewer.FileAssoc.Wdp"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".bmp" "PhotoViewer.FileAssoc.Bitmap"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".jpe" "PhotoViewer.FileAssoc.Jpeg"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".jpeg" "PhotoViewer.FileAssoc.Jpeg"
sp "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" ".gif" "PhotoViewer.FileAssoc.Gif"
