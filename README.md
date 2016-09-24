# Debloat Windows 10

This project collects Powershell scripts which help to *debloat* Windows 10,
tweak common settings and install basic software components.

I develop those scripts on a Windows 10 Professional 64-Bit (English) virtual
machine. Please let me know if you encounter any issues with other Windows 10
versions.

Home Edition and different languages are not supported. Let me know of you fork
this repo for fixing Home Edition or a different language.

Note that **there is no undo**, I recommend only using these scripts on a fresh
install (including updates). Test everything after running them before
continuing with something else. Also there is no guarantee that everything will
work after future updates since I cannot predict what Microsoft will do next.

## Download Latest Version

Code located in the `master` branch is under development (for now).

- [Download [zip]](https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip)

## Execution

Enable execution of PowerShell scripts:

    PS> Set-ExecutionPolicy Unrestricted

Unblock PowerShell scripts and modules within this directory:

    PS > ls -Recurse *.ps1 | Unblock-File
    PS > ls -Recurse *.psm1 | Unblock-File

## Usage

1. Install all available updates for your system.
2. Edit the scripts to fit your need.
3. Run the scripts
4. `PS > Restart-Computer`

## Startmenu

In the past I included small fixes to make the startmenu more usable, like
removing default tiles, disabling web search and so on. This is no longer the
case since I am that fed up with it. This fucking menu breaks for apparently
know reason, is slow, is a pain to configure / script and even shows ads out of
the box!

Please replace it with something better, either use [Classic Shell] or [Start
is Back], but stop using that shit.

[Classic Shell]: <http://www.classicshell.net/>
[Start is Back]: <http://startisback.com/>

## Known Issues

### Startmenu Search

After running the scripts, the startmenu search-box may no longer work on newly
created accounts. It seems like there is an issue with account initilization
that is triggered when disabling the GeoLocation service. Following workaround
has been discovered by BK from Atlanta:

1. Delete registry key `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\TriggerInfo\3`
2. Re-enable GeoLocation service (set startup type to `Automatic`)
3. Reboot
4. Login with the account having the stated issue
5. Start Cortana and set your preferences accordingly (web search and whatnot)

You may now disable the GeoLocation service again, the search box should remain
functional.

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
