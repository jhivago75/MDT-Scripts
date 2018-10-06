#########################################################################################################################
#
#   Author    : Jhivago
#   FileName  : Power_Profile.ps1
#   License   : GLP v3.0. See: https://www.gnu.org/licenses/gpl-3.0.en.html
#   Version   : 1.0
#   Revision  : R2 - 2018.10.05
#   Created   : 2018.10.05
#
#   Notes     : Only changes the power settings for the pluged in state not the battery state.
#
#   Changes   : v1.0 R1 - Inital Version.
#               v2.0 R1 - Added configuration for USB Selective Suspend
#               v2.0 R1 - Added logging for MDT
#
#   To do     : - Option to take parameters?
#
#
#########################################################################################################################
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |   
#|{>/-------------------------------------------------------------\<}|             
#|: | Author:  Aman Dhally                                         
#| :| Email:   amandhally@gmail.com                  
#|: | Purpose:                                                           
#| :|            Check the PowerScheme on the Laptop and Assign the Desired One  
#|: |                                                              
#|: |                                Date: 09-11-2011              
#| :|     /^(o.o)^\     
#|{>\-------------------------------------------------------------/<}| 
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = | 
#+-------------------------------------------------------------------+#
# Powercfg - L # to get the Available list of all Power Settings  schemes 
# powercfg  -L# 
# 
#Existing Power Schemes (* Active) 
#----------------------------------- 
#Power Scheme GUID: 1ca6081e-7f76-46f8-b8e5-92a6bd9800cd  (Maximum Battery 
#Power Scheme GUID: 2ae0e187-676e-4db0-a121-3b7ddeb3c420  (Power Source Opt 
#Power Scheme GUID: 37aa8291-02f6-4f6c-a377-6047bba97761  (Timers off (Pres 
#Power Scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e  (Balanced) 
#Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance 
#Power Scheme GUID: a1841308-3541-4fab-bc81-f71556f20b4a  (Power saver) 
#Power Scheme GUID: a666c91e-9613-4d84-a48e-2e4b7a016431  (Maximum Performa 
#Power Scheme GUID: de7ef2ae-119c-458b-a5a3-997c2221e76e  (Energy Star) 
#Power Scheme GUID: e11a5899-9d8e-4ded-8740-628976fc3e63  (Video Playback) 
# 
# 
# 
 
##### Variables  # # #  # # # 
 
 
## I want to Use Balanced as Deault PowerScheme on All Laptops # 
 
#$x = '381b4222-f694-41f0-9685-ff5bb260df2e'   

# Get the computer name
$MyComputer = $Env:COMPUTERNAME

# Determine where to do the logging 
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 
$logPath = $tsenv.Value("LogPath") 
$logFile = "$logPath\$($myInvocation.MyCommand).log"
 
# Start the logging 
Start-Transcript $logFile
Write-Output "Logging to $logFile"

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

## I want to Use High Performance as Deault PowerScheme on All Desktops #
$x = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'

# Lets Check what is our Current Active "Power Scheme" and put it on a Variable 
 
$currScheme = POWERCFG -GETACTIVESCHEME  
 
# Put $CurrScheme in a variable and Spilt is so that we can get the GUID of Active "Power Scheme" 
 
$y = $currScheme.Split() 

############################# 
### Script Starts Here ###### 
############################# 
 
 
if ($y[3] -eq $x) { 
 
    Write-Output "You Have correct Settings, Nothing to Do!!! " 
     
    } else { 
     
            Write-Output  "You Have Wrong Power Scheme Set, let me fix it for you"  
            
            Write-Host "$x"
             
            PowerCfg -SetActive $x 

            PowerCfg -x disk-timeout-ac 0

            if ($MyComputer -Like 'Shop??-PC') {
                PowerCfg -x monitor-timeout-ac 0
            } else {
                PowerCfg -x monitor-timeout-ac 15
            }

            PowerCfg -x hibernate-timeout-ac 0

            PowerCfg -x standby-timeout-ac 0

            PowerCfg /SETACVALUEINDEX 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

            #Subgroup GUID: 2a737441-1930-4402-8d77-b2bebba308a3  (USB settings)
            #Power Setting GUID: 48e6b7a6-50f5-4782-a5d4-53bb8f07e226  (USB selective suspend setting)
            #Possible Setting Index: 000
             
            Write-Output "PowerScheme Sucessfully Applied" 
             
            } 
             
# Stop logging 
Stop-Transcript

##### End of Script # # # # 
#### Its Tested on Windows 7 and 10 ##########