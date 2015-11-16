# Debloat Windows 10

This project collects Powershell scripts which help to *debloat* Windows 10,
tweak common settings and install basic software components.

## Download Latest Version

Code located in the `master` branch is under development (for now).

- [Download [zip]](https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip)

## Description

Windows 10 comes with a whole bunch features most (power-)user do not use /
want. Therefore the scripts provided should help getting rid of them easily.

I try to keep sensible defaults for all scripts but you'll be better of editing
them before execution to fit your personal needs. Don't forget to run them with
administrative privileges and have Powershell execution policy set to
`Unrestricted`.

    PS> Set-ExecutionPolicy Unrestricted

Alternatively you can run the script as an argument to Powershell with
execution policy set to bypass.

    C:\> PowerShell.exe -ExecutionPolicy Bypass -File script-file.ps1

I develop those scripts on a Windows 10 Professional 64-Bit virtual machine.
Please let me know if you encounter any issues with other Windows 10 versions.

## Usage

1. Install all available updates for your system.
2. Edit the scripts to fit your need.
3. Run the edited scripts (recommended order)
    1. `fix-privacy-settings.ps1`
    2. `disable-scheduled-tasks.ps1`
    3. `disable-windows-features.ps1`
    4. `disable-services.ps1`
    5. ...
4. Reboot!

## Interactivity

The scripts are designed to run without any user-interaction. Modify them
beforehand. If you want a more interactive approach check out
[DisableWinTracking](https://github.com/10se1ucgo/DisableWinTracking) from
[10se1ucgo](https://github.com/10se1ucgo).

## Liability

**All scripts are provided as is and you use them at your own risk.**

## Contribute

I would be happy to extend the collection of scripts. Just open an issue or
send me a pull request.

### Thanks To

- [10se1ucgo](https://github.com/10se1ucgo)
- [Plumebit](https://github.com/Plumebit)
- [aramboi](https://github.com/aramboi)
- [maci0](https://github.com/maci0)
- [narutards](https://github.com/narutards)
- [tumpio](https://github.com/tumpio)

## License

    "THE BEER-WARE LICENSE" (Revision 42):

    As long as you retain this notice you can do whatever you want with this
    stuff. If we meet some day, and you think this stuff is worth it, you can
    buy us a beer in return.

    This project is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.
