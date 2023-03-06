Import-Module '480-utils' -Force
#Call the Banner Function
480Banner
$conf = Get-480Config -config_path "/home/jwells/Documents/Tech-Journal/SEC-480/480.json"
480Connect -server $conf.vcenter_server
Write-Host "Selecting your VM"
$vm = Select-Vm -folder $conf.vm_folder
Write-Host "Selecting Snapshot"
$snapshot = Select-Snapshot -snap_name $conf.usableSnap -selected_vm $vm
