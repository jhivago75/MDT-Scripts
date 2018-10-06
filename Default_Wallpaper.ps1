#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : Default_Walpaper.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R1 - 2018.10.05
#   Created   : 2018.10.05
#
#   Changes   : v1.0 R1 - Inital Version.
#
#   To do     : - Option to take parameter?
#
#
#########################################################################################################################

<# 
 .Synopsis
    Sets a custom default wallpaper for all new users.

 .Description
    Sets a custom default wallpaper for all new users.
    See https://www.winsysadminblog.com/2016/08/setting-the-default-wallpaper-on-a-windows-10-image-deployment-through-mdt/

    Requirements: 
        * PowerShell Version 5 or later.

 .Parameter NONE
    There are no parameters.

 .Example
    Default_Walpaper.ps1

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

takeown /A /F %SystemRoot%\web\wallpaper\windows\img0.jpg

takeown /A /F %SystemRoot%\web\4k\Wallpaper\Windows\*.*

icacls %SystemRoot%\web\wallpaper\windows\img0.jpg /grant "Administrators":F

icacls %SystemRoot%\web\4k\Wallpaper\Windows\*.* /grant "Administrators":F

copy /y %SystemRoot%\web\wallpaper\Zydeco\zydeco.jpg %SystemRoot%\web\wallpaper\windows\img0.jpg

del /q %SystemRoot%\web\4k\Wallpaper\Windows\*.*

# Stop logging 
Stop-Transcript