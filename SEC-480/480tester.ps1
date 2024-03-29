Import-Module '480-utils' -Force
#Call the Banner Function
480Banner

#Read the configuration file located at 480.json
$conf = Get-480Config -config_path "/home/jwells/Documents/Tech-Journal/SEC-480/480.json"

#Connect to our Vcenter server with 480Connect
480Connect -server $conf.vcenter_server

#$vmhost = Select-VMWareHost -hostname $conf.esxi_host
#New-Network -userHost $vmhost

#Select your folder
$folder = Read-Host "What is the folder you would like to select from?"
$vm = Select-Vm -folder $folder
Get-IP -chosenVM $vm

#Start-ProperVM -folder $folder

#Set-NetworkAdapterVM -folder $folder
