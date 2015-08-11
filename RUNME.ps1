#   Description:
# Simple cli helper tool to aid in running the scripts

#Requires -Version 4.0

# Self elevate
if(!([Security.Principal.WindowsPrincipal] `
  [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  Start-Process powershell.exe -Verb RunAs "-NoProfile -NoExit -NoLogo -ExecutionPolicy Bypass -File `"$PSCommandPath`""
  exit
}

'Debloat Windows 10 scripts project'
''
@"
This project is an effort to collect scripts which help debloating
Windows 10. This tool will aid in running the scripts inside the scripts
directory. After selecting number of script(s), possible actions are
Show Info and Run Script(s).
"@

$ScriptsPath = '{0}\scripts' -f $PSScriptRoot
$Scripts = Get-ChildItem $ScriptsPath |
    Where-Object { $_.Extension -eq '.ps1' } |
    ForEach-Object { $_.BaseName}

Import-Module $PSScriptRoot\lib\CLIAid.psm1

$on = $true
while ($on) {
  ''
  'List of available scripts:'
  Show-List -Of (0..($Scripts.Length - 1)) -In $Scripts
  ''
  'Enter number of scripts to be processed (ex: 1 2 3 or 1-3)'
  $Selection = Read-Host
  $SelectedScripts = Convert-NumericSelection $Selection $Scripts.Length
  if ($SelectedScripts.Length -gt 0)
  {
    $Actions = 'null','Show Info','Run Script(s)'
    $SelectedAction = 0
    do {
      ''
      'Select an action'
      '1: Show Info, 2: Run Script(s), n/a: Return'
      $SelectedAction = Read-Host
      switch ($SelectedAction) {
        1 {
          ''
          'List of descriptions for selected scripts'
            foreach ($i in $SelectedScripts)
            {
              ''
              Show-PrettyListItem -Index $i -Title $Scripts[$i]
              Read-Description ('{0}\{1}.ps1' -f $ScriptsPath,$Scripts[$i])
            }
        }
        2 {
          ''
          'Selected scripts:'
          Show-List -Of $SelectedScripts -In $Scripts
          ''
          'Selected action: {0}' -f $Actions[$SelectedAction]
          $Confirm = Read-Host 'Do you want to continue? (Yes/No)'
          if ($Confirm.ToLower() -match 'y(es)?')
          {
            $Processed = 1
            foreach ($i in $SelectedScripts)
            {
              '({0}/{1}) running script: {2}' -f $Processed, $SelectedScripts.Length, (Show-PrettyTitle $Scripts[$i])
              Invoke-Expression ('{0}\{1}.ps1' -f $ScriptsPath,$Scripts[$i])
              $Processed++
            }
          }
          $on = $false
        }
        default {
          break
        }
      }
    } while ($SelectedAction -eq 1)
  }
  else
  {
    break
  }
}
exit
