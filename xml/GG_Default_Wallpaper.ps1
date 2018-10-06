<#
Set a custom default wallpaper for all new users
See https://www.winsysadminblog.com/2016/08/setting-the-default-wallpaper-on-a-windows-10-image-deployment-through-mdt/
#>

# Get the computer name
$MyComputer = $Env:COMPUTERNAME

$ScriptPath = "Z:\Applications\_scripts"
$_LOGFILE = "$ScriptPath\Script_Logs\GG_Default_Wallpaper_$MyComputer.log"

Start-Transcript -Path $_LOGFILE

takeown /A /F %SystemRoot%\web\wallpaper\windows\img0.jpg

takeown /A /F %SystemRoot%\web\4k\Wallpaper\Windows\*.*

icacls %SystemRoot%\web\wallpaper\windows\img0.jpg /grant "Administrators":F

icacls %SystemRoot%\web\4k\Wallpaper\Windows\*.* /grant "Administrators":F

copy /y %ScriptPath%\GGEnt\GGtoughbookwallpaper.jpg %SystemRoot%\web\wallpaper\windows\img0.jpg

del /q %SystemRoot%\web\4k\Wallpaper\Windows\*.*

Stop-Transcript
