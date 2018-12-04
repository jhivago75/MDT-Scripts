
#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : DumpVars.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R1 - 2018.10.05
#   Created   : 2018.10.05
#
#   Changes   : v1.0 R1 - Inital Version.
#
#
#
#########################################################################################################################

<# 
 .Synopsis
    Dumps Task sequence variables.

 .Description
    Dumps Task sequence variables. Original source:
    https://blogs.technet.microsoft.com/mniehaus/2010/04/26/dumping-task-sequence-variables/

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter NONE
    There are no parameters.

 .Example
    DumpVar.ps1

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

# Write all the variables and their values
$tsenv.GetVariables() | % { Write-Host "$_ = $($tsenv.Value($_))" }

# Stop logging
Stop-Transcript 