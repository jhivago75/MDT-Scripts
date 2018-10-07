#########################################################################################################################
#
#   Author    : Peter Löfgren  1.0 R1
#   Author    : Jhivago 2.0 R1
#   FileName  : Internet-Access.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 2.0
#   Revision  : R1 - 2018.10.05
#   Created   : 2018.10.05
#
#   Changes   : v1.0 R1 - Inital Version.
#               v2.0 R1 - Added logging.
#
#   To do     : - Option to take parameters?
#
#
#########################################################################################################################

<# 
 .Synopsis
    Enables or disables internet access.

 .Description
    Used to Block Internet Access to prevent Microsoft Store App Updates during a buid/capture sequence.
    See https://syscenramblings.wordpress.com/2017/10/25/windows-10-1709-reference-image/.

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter Disable
    Reinstates Internet access.

 .Example
    Internet-Access.ps1

    Inserts a firewall rule blocking ports 80,443.

 .Example
    Internet-Access.ps1 -Disable

    Removes the firewall rule blocking ports 80,443.

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

## Creates the disable option used by the script
param (
   [Parameter(Mandatory=$False,Position=0)]
   [Switch]$Disable
)
 
## If the Disable command line option is not added, the script adds a Firewall Rule to block traffic on ports 80 (http) and 443 (https).
If (!$Disable)
{
   Write-Output "Adding internet block"
   New-NetFirewallRule -DisplayName "Block Outgoing 80, 443" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443
}
 
## If the Disable command line option is added, the script removes the Firewall Rule created above.
If ($Disable)
{
   Write-Output "Removing internet block"
   Get-NetFirewallRule -DisplayName "Block Outgoing 80, 443" | Remove-NetFirewallRule
}

# Stop logging 
Stop-Transcript