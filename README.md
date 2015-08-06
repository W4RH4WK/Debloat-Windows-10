# Debloat Windows 10

This project is an effort to collect scripts which help *debloating* Windows
10.

I personally find the state Windows 10 comes in quite shocking / scary and want
to have very slim, scriptable solution to remove and disable Windows 10's
features most people do not need nor want.

The scripts provided consists of Powershell scripts, you should have no
problems altering and using them to fit your needs. Do not forget to set the
execution policy for Powershell scripts. And of course, how have to run them
with administrative privileges.

    PS> Set-ExecutionPolicy Unrestricted

Alternatively you can run the script as an argument to Powershell with
execution policy set to bypass.

    C:\> PowerShell.exe -ExecutionPolicy Bypass -File script-file.ps1

Look at the scripts most of them are only a couple of lines long and it should
be pretty obvious what they are doing.

I develop those scripts on a Windows 10 Professional 64-Bit virtual machine.
Please let me know if you encounter any issues with other Windows versions.

## Privacy Settings

I am also working on a script which sets the privacy settings of the current
user. This is work in progress and far from being complete. I will try to keep
them up-to-date as good as possible but do not rely on them since they may be
outdated.

## Liability

**All scripts are provided as is and you use them at your own risk.**

## Contribute

I would be happy to extend the collection of scripts. Just open an issue or
send me a pull request.

## License

    "THE BEER-WARE LICENSE" (Revision 42):

    As long as you retain this notice you can do whatever you want with this
    stuff. If we meet some day, and you think this stuff is worth it, you can
    buy us a beer in return.

    This project is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.
