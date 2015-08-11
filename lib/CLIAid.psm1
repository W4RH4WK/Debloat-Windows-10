# Helper functions for CLI

$TextInfo = (Get-Culture).TextInfo

function Convert-NumericSelection
{
<#
.DESCRIPTION
Parse numeric selection.
Supports multiple selections and range selection.

.PARAMETER Selection
Selection input string.

.PARAMETER MaxValue
Maximum allowed value for selection.

.EXAMPLE
Parse-NumericSelection -Selection "1-4 2 1 5-6" -MaxValue 10
Returns an array @(1,2,3,4,5,6)
Parse-NumericSelection -Selection "1-4 2 1 5-6" -MaxValue 4
Returns an empty array
Parse-NumericSelection -Selection "a b c" -MaxValue 10
Returns an empty array

.NOTES
Parsed selection is sorted and duplicates are removed.
#>
  param([string]$Selection, [int]$MaxValue)
  $Selected = @()
  if ($Selection -match '^(\d+(\-\d+)?\s?)+$')
  {
    $Values = $Selection.Split()
    foreach ($Value in $Values)
    {
      $Range = $Value.Split('-')
      if ($Range[0] -NotIn 1..$MaxValue -or
        $Range.Length -eq 2 -and $Range[1] -NotIn 1..$MaxValue)
      {
        $Selected = @()
        break
      }
      if ($Range.Length -eq 2)
      {
        $Selected += ($Range[0] - 1)..($Range[1] - 1)
      }
      else
      {
        $Selected += ($Range[0] - 1)
      }
    }
  }
  return $Selected | select -uniq | sort
}

function Show-PrettyTitle
{
<#
.DESCRIPTION
Format title.

.PARAMETER Title
String of the title to be formatted.

.EXAMPLE
Show-PrettyTitle "my-script"
Returns "My Script"
#>
  param([string]$Title)
  $TextInfo.ToTitleCase($Title.Replace('-',' '))
}

function Show-PrettyListItem
{
<#
.DESCRIPTION
Format title as a list item.

.PARAMETER Index
List item's index number.

.PARAMETER Title
Title string to format.

.EXAMPLE
Show-PrettyListItem -Index 1 -Title "my-script"
Returns " 1. My Script"

.NOTES
Uses Show-PrettyTitle to format the title.
#>
  param([int]$Index, [string]$Title)
  '{0,2}. {1}' -f ($Index + 1),(Show-PrettyTitle $Title)
}

function Show-List
{
<#
.DESCRIPTION
List items in array as an ordered list.

.PARAMETER Of
Array of indexes of items.

.PARAMETER In
Array containing the listed items.

.EXAMPLE
Show-List -Of (1..4) -In @(0,1,2,3,4,5)
#>
  param([array]$Of, [array]$In)
  foreach ($i in $Of)
  {
    Show-PrettyListItem -Index $i -Title $In[$i]
  }
}

function Read-Description
{
<#
.DESCRIPTION
Read the first lines of comments in the script's source file.

.PARAMETER ScriptPath
Full path for script's source file.

.EXAMPLE
Read-Description "C:\MyScript.ps1"
#>
  param([string]$ScriptPath)
  $Description = @()
  $Source = Get-Content $ScriptPath
  foreach ($Line in $Source)
  {
    if ($Line[0] -eq '#') {
      $Description += $Line.Substring(1).Trim()
    }
    else
    {
      break
    }
  }
  return $Description
}
