Import-Module '480-utils' -Force
#Call the Banner Function
480Banner

#Read the configuration file located at 480.json
$conf = Get-480Config -config_path "/home/jwells/Documents/Tech-Journal/SEC-480/480.json"

#Connect to our Vcenter server with 480Connect
480Connect -server $conf.vcenter_server

#Select the vm you want to create a linked clone of with Select-Vm
#Write-Host "Selecting your VM"
#$vm = Select-Vm -folder $conf.vm_folder

#Get-IP -chosenVM $vm

$vmhost = Select-VMWareHost -hostname $conf.esxi_host
New-Network -userHost $vmhost