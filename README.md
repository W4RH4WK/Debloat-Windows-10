# Debloat and Secure Windows 10

- [Download [zip]](https://github.com/supmaxi/Debloat-Windows-10/archive/master.zip)

## HOW TO RUN .PS1 (POWERSHELL SCRIPTS) FILES
Open PowerShell (or PowerShell ISE) as an Administrator

Navigate to the scripts folder of where you have downloaded / extracted the archive, eg:

cd C:\Users\USERNAME\Downloads\Debloat-Windows-10-master\Debloat-Windows-10-master\scripts

Enable execution of PowerShell scripts:

    Set-ExecutionPolicy Unrestricted -Scope CurrentUser
    
    Set-ExecutionPolicy Unrestricted -Force

Unblock PowerShell scripts and modules within this directory:

    ls -Recurse *.ps*1 | Unblock-File
    
If you do not do the above, the powershell scripts will not have elevated permissions to do the required tasks, and the majority will fail to work.

Now, you are ready to actually run the scripts one by one:

Type the following: .\SCRIPTNAME.ps1
where 'SCRIPTNAME' will need to be the actual scripts name, for example: .\disable-services.ps1

## HOW TO RUN .BAT FILES (CMD SCRIPTS)
For .bat files, simply right click and 'run as administrator'.

## I HAVE USED TOOLS LIKE THESE BEFORE, AND THEY WRECKED MY START / SEARCH MENU , WILL THIS DO THE SAME ??
NO , i have run every one of these scripts on all my PC's and the Windows start/search is fully intact and responsive, without any issues what so ever. The mistake other tools make is removing a specific cortana module which kills the search bar, we disable cortana without doing that.

## CAUTIONS / WARNINGS / THINGS TO NOTE:
1. experimental_unfuckery.ps1: Dont be scared to use it - just remember 2 things - (1) removed packages may no longer be installable again (this includes defender). Most other scripts disable things, whereas this removes things. (2) RUN THIS SCRIPT LAST, after you've finished running all the other ones. VERY IMPORTANT!
2. XBOX: We disable the xbox related services in these scripts, so keep that in mind if you need xbox services (you can always comment out # the lines which affect xbox related scripts to prevent that).
3. MS STORE: We disable and remove the Microsoft App Store, so keep that in mind if you want to keep the MS App Store (you can always comment out # the lines which affect MS APP Store related scripts to prevent that).
3. DEFENDER: We disable defender in some scripts, and fully remove defender in experimental_unfuckery.ps1, so keep that in mind if you want to keep the Defender (you can always comment out # the lines which affect Defender related scripts to prevent that).

In saying that, i recommend to remove client-side Defender, and run the scripts as they are configured by default (to my personal taste).

What to do without defender? Answer = SIMPLEWALL + Group Policy (Windows defender firewall with advanced security) - yes, thats right - youll still have this more powerful 'defender' in group policy

## SIMPLEWALL
https://www.henrypp.org/product/simplewall
https://github.com/henrypp/simplewall

Very sophisticated, effective, opensource firewall - which has built in MS telemetry blocking. Highly configurable and simple to use.

This will replace Defender (which is trash, especially in its firewall area - new rules pop up out of no where, allowing access to things you never gave permission too, all by itself. Even when you disable rules it automatically generated, you will find later that it adds new rules again to bypass your configuration).

## GROUP POLICY
Group policy > Windows Settings > Security Settings > Windows Defender Firewall With advanced Security
This is the 'parent' defender, which can override the standard defender (that we removed). It is a common tactic of malicious actors to take over your machine. If you never configured the group policy defender, they can bypass all your 'standard' defender rules through group policies defender application. So this is a great step to learn how windows really works, and how to secure it properly.

You'll also want to configure other security related group policy settings.

## How about anti-virus?
See the guide on reddit below, to make your decision. And if you dont feel secure with the options and info presented, then go with a third party AV that doesnt do 'cloud based' protection (or has the option to disable that functionality).

## Complete Windows 10 Privacy/Security Guide here: https://www.reddit.com/r/privacytoolsIO/comments/fwgvsb/windows_10_best_privacy_practices/
