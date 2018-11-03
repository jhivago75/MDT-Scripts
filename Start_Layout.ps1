#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : Start_Layout.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 2.0
#   Revision  : R1 - 2018.10.07
#   Created   : 2018.10.05
#
#   Changes   : v1.0 R1 - Inital Version.
#               V2.0 R1 - Converted hardcoded paths to enviroment variables.
#               V2.0 R1 - Added check to see if we are on x86 or x64.
#
#   To do     : - Option to take parameters?
#
#
#########################################################################################################################

<# 
 .Synopsis
    Imports a customized Start Menu/Taskbar layout.

 .Description
    Imports a customized Start Menu/Taskbar layout created with Export-StartLayout –path <path><file name>.xml .
    See https://docs.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar to add taskbar customizations.

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter NONE
    There are no parameters.

 .Example
    Start_Layout.ps1

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

# Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

# Get the deployment root
$DeployRoot = $tsenv.Value("DEPLOYROOT")

# Set the path to the nesessary files
$XMLFiles = "$DeployRoot\Applications\_Scripts\Files\xml"

# Test if our apps are installed and set to $true or $false
if (Test-Path "$env:ProgramFiles (x86)\Microsoft Office\root") {
    $Office = $true
} elseif (Test-Path "$env:ProgramFiles\Microsoft Office\root") {
    $Office = $true
} else { $Office = $false }

if (Test-Path "$env:ProgramFiles (x86)\Intuit") {
    $QB = $true
} elseif (Test-Path "$env:ProgramFiles\Intuit") {
    $QB = $true
} else { $QB = $false }


# Set our layout file
if (($Office) -and ($QB)) {
    $NewLayoutFile = "$XMLFiles\Start_Layout_Office_QB.xml"
} elseif (($Office) -and !($QB)) {
    $NewLayoutFile = "$XMLFiles\Start_Layout_Office.xml"
} else {
    $NewLayoutFile = "$XMLFiles\Start_Layout.xml"
}

Write-Output "Writing $NewLayoutFile to $MyComputer"

Import-StartLayout -LayoutPath "$NewLayoutFile" -MountPath C:\

Write-Output "Done"
 
# Stop logging 
Stop-Transcript
