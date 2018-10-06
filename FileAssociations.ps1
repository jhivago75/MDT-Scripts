#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : FileAssociations.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R1 - 2018.10.05
#   Created   : 2018.10.05
#
#   Changes   : v1.0 R1 - Inital Version.
#
#   To do     : - Option to take parameters?
#
#
#########################################################################################################################

<# 
 .Synopsis
    Imports a customized Start Menu/Taskbar layout.

 .Description
    Imports a customized set of Default File Associations created with 
    dism /online /Export-DefaultAppAssociations:"%UserProfile%\Desktop\MyDefaultAppAssociations.xml"

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter NONE
    There are no parameters.

 .Example
    FileAssociations.ps1

 .Link
    Licensed under GLP v3.0. See:
    https://www.gnu.org/licenses/gpl-3.0.en.html

 .Notes
    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
    FITNESS FOR A PARTICULAR PURPOSE.

    The script is provided AS IS without warranty of any kind. We further disclaim all
    implied warranties including, without limitation, any implied warranties of merchantability
    or of fitness for a particular purpose. The entire risk arising out of the use or performance
    of the sample and documentation remains with you. In no event shall anyone else involved in the
    creation, production, or delivery of the script be liable for any damages whatsoever (including,
    without limitation, damages for loss of business profits, business interruption, loss of business
    information, or other pecuniary loss) arising out of the use of or inability to use the sample or 
    documentation.

#>

# Determine where to do the logging 
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$logPath = $tsenv.Value("LogPath") 
$logFile = "$logPath\$($myInvocation.MyCommand).log"
 
# Start the logging 
Start-Transcript $logFile
Write-Output "Logging to $logFile"

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

# Get the computer name
$MyComputer = $Env:COMPUTERNAME

# Test if Office is installed
if (Test-Path -Path "C:\Program Files (x86)\Microsoft Office\root") {
    $NewAssocFile = "Z:\Applications\_Scripts\xml\AppAssoc_Office.xml"
} else {
    $NewAssocFile = "Z:\Applications\_Scripts\xml\AppAssoc.xml"
}

Write-Output "Writing $NewAssocFile to $MyComputer"

dism /online /Import-DefaultAppAssociations:"$NewAssocFile"

Write-Output "Done."
 
# Stop logging 
Stop-Transcript