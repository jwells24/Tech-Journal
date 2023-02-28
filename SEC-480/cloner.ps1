$vm = Get-VM -Name $args[0]     
$snapshot = Get-Snapshot -VM $vm -Name "Base"
$vmhost = Get-VMHost -Name $args[1]
$ds = Get-DataStore -Name $args[2]
$linkedClone = "{0}.linked" -f $vm.name

$linkedvm = New-VM -LinkedClone -Name $linkedClone -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datstore $ds

$newvm = New-VM -LinkedClone -Name $args[3] -VM $linkedvm -VMHost $vmhost -Datastore $ds

$newvm | New-Snapshot -Name "Base"

$linkedvm | Remove-VM
