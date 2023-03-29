Import-Module '480-utils' -Force
#Call the Banner Function
480Banner

#Read the configuration file located at 480.json
$conf = Get-480Config -config_path "/home/jwells/Documents/Tech-Journal/SEC-480/480.json"

#Connect to our Vcenter server with 480Connect
480Connect -server $conf.vcenter_server

#Select the vm you want to create a linked clone of with Select-Vm
Write-Host "Selecting your VM"
$vm = Select-Vm -folder "Base-Vms"

#Select the snapshot you want to use with Select-Snapshot
Write-Host "Selecting Snapshot"
$snapshot = Select-Snapshot -snap_name $conf.usableSnap -selected_vm $vm

#Identify the VMhost you want to use with Select-VMWareHost
Write-Host "Identifying VMHost"
$vmhost = Select-VMWareHost -hostname $conf.esxi_host

#Allow the user to input the name of the datastore they want to use, then select it with Select-Datastore
Write-Host "Selecting Datastore"
$ds = Select-Datastore -dstoreName "datastore2-super7"

#Allow the user to input what they want to name their new linked clone, then create the new VM with New-LinkedClone
$linkedclone = Read-Host "Enter the name you would like to call your linked clone"
New-LinkedClone -ChosenName $linkedclone -chosenVm $vm -chosenSnap $snapshot -chosenHost $vmhost -chosenStore $ds

#Set the network adapter for the linked machine
Set-NetworkAdapterVM -name $linkedclone

#Verify the new VM was created 
Write-Host -ForegroundColor Green "Successfully created your VM"