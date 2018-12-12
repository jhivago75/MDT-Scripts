#requires -version 5
#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : XXX.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R1 - YYYY.MM.DD
#   Created   : YYYY.MM.DD
#
#   Changes   : v1.0 R1 - Inital Version.
#
#   To do     : 
#
#
#########################################################################################################################

<#

 .Synopsis
    <Overview of script.>

 .Description
    <Brief description of script and its requirements.>

    Requirements: 
        * PowerShell Version 5 or later.
    
 .Parameter Parameter_Name
    <Brief description of parameter input required. Repeat this attribute if required.>

 .INPUTS
    <Inputs if any, otherwise state None>

 .OUTPUTS Log File
    The script log file stored in $LogPath\yyyy-MM-dd-HH-mm-ss-<scriptname>.log.
    $LogPath defaults to $ScriptRoot\Logs if not otherwise specfied.

 .Example
    <Example goes here.>

    <Example explanation goes here.  Repeat this attribute for more than one example.>
 
 .Link
    Get PSLogging Module here:
    http://9to5it.com/powershell-logging-v2-easily-create-log-files/

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

#############################
# Start Script Parameters
#

[Cmdletbinding()]
Param(
    [Parameter(Mandatory = $True,
               HelpMessage = 'Help message here ')]
    [String]$NewParam
)

#
#  End Script Parameters
#############################

#############################
# Start Initialisations
#

# Set Error Action to Silently Continue.
$ErrorActionPreference = "SilentlyContinue"

# Import Modules & Snap-ins.
#Import-Module ADDSDeployment

#  End Initialisations
#############################

#############################
# Start Declarations
#

#Script Version.
$sScriptVersion = "3.0 R1"

# Get the current date.
$Date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"

# Determine wether or not we are in a deployment enviroment
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
if ([string]::IsNullOrEmpty($tsenv)) {
    $logpath = "$PSScriptRoot\Logs"
} else {
    $logPath = $tsenv.Value("LogPath")
}
# Determine where to do the logging 
$logFile = "$logPath\$($myInvocation.MyCommand)-$Date.log"

#
#  End Declarations
#############################

#############################
# Start Function Definitions
#

<#
Function Main 
{
    Param ()

    Begin 
    {
    Write-Output "Starting Main Function."
    }
    Process 
    {
        Try 
        {
            # Start with a clean screen.
            clear-host

            #############################
            #  Start Basic Sanity Checks
            #

            # Make sure we are running elevated. Use -Reload parameter to elevate and continue, otherwise exit.
            #CheckElevation -Reload
            CheckElevation
    
            #
            #  End Basic Sanity Checks
            #############################

            #############################
            #  Start Main App
            #

            <Main exicution code goes here.>

            #
            #  End Main App
            #############################
        }
        Catch 
        {
            Write-Error $_.Exception
            Break
        }
    }
    End 
    {
        If ($?) 
        {
            Write-Output "Completed Successfully."
            WWrite-Output " "
        }
    }
}
#>

<#
Function <FunctionName> 
{
    Param ()

    Begin 
    {
        Write-Output "<description of what is going on>..."
    }

    Process 
    {
        Try 
        {
            <Code goes here.>
        }
        Catch 
        {
            Write-Error $_.Exception
            Break
        }
    }
    End 
    {
        If ($?) 
        {
            Write-Output "Completed Successfully."
            Write-Output " "
        }
    }
}
#>

#
#  End Function Definitions
#############################

#############################
# Start Main Execution
#

# Start the logging
Start-Transcript -Path $logFile
Write-Output "Logging to $logFile"

Main

Stop-Transcript


#
#  End Main Execution
#############################

