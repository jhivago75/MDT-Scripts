#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : bld_vpn.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R1 - 2018.08.14
#   Created   : 2018.08.14
#
#   Changes   : v1.0 R1 - Inital Version.
#
#   To do     : - Option to take .csv file input?
#               - GUI input option?
#
#
#########################################################################################################################

<# 
 .Synopsis
    Creates a global VPN connection.

 .Description
    Creates a global L2tp VPN connection. Tested with Unifi Security Gateway Pro 4.
    The $VPNServer variable will hake either and IP address or FQDN.
    This approach allows logging in to the VPN from the Windows Login screen.

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter NONE
    Does not take any parameters.

 .Example
    BLD_VPN.ps1

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
[Cmdletbinding()]
Param(
    [Parameter(Mandatory = $True,
               HelpMessage = 'Please provide the path of the CSV file containing the users')]
    [String]$PathToCSVFile
)

# Determine where to do the logging 
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$logPath = $tsenv.Value("LogPath") 
$logFile = "$logPath\$($myInvocation.MyCommand).log"
 
# Start the logging 
Start-Transcript $logFile
Write-Output "Logging to $logFile"

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

# Import the csv file
$VPNSettings = Import-Csv $PathToCSVFile

foreach ($VPNSetting in $VPNSettings) {
    # Set the values needed to set this up
    $VPNName = $VPNSetting.name             # Display name
    $VPNServer = $VPNSetting.server         # Remote VPN server IP/FQDN
    $RemoteSubnet = $VPNSetting.subnet      # Remote IP block we need access to
    $DNSSuffix = $VPNSetting.suffix         # Remote domain DNS Search Suffix
    $Psk = $VPNSetting.psk                  # VPN Pre-shared Key
    $Action = $VPNSetting.Action            # Accepts New, Replace or Remove

    if (($Action -eq "Replace") -or ($Action -eq "Remove")) {
        # Remove any prevoius connections with the same name
        Remove-VpnConnection -Name "$name" -AllUserConnection -Force 
        Remove-VpnConnection -Name "$name" -Force 
    }

    if (($Action -eq "Replace") -or ($Action -eq "New")) {
        # Create the VPN connection
        Add-VpnConnection -Name "$VPNname" -ServerAddress "$VPNServer" -TunnelType L2tp -EncryptionLevel Required -AuthenticationMethod MSChapv2 -SplitTunneling -L2tpPsk "$Psk" -Force -RememberCredential -DnsSuffix "$DNSSuffix" -PassThru -AllUserConnection
        Add-VpnConnectionRoute -ConnectionName "$VPNname" -DestinationPrefix "$RemoteSubnet" -PassThru -AllUserConnection
        start-sleep -seconds 30
    }
}

# Stop logging 
Stop-Transcript