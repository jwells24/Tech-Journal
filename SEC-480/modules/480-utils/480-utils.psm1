function 480Banner ()
{
    Write-Host "Hello SYS480"
}
# Connect to a server
Function 480Connect([string] $server)
{
    $conn = $global:DefaultVIServer
    if ($conn)
    {
        $msg = "Already Connected to: {0}" -f $conn

        Write-Host -ForegroundColor Green $msg
    }else 
    {
        $conn = Connect-VIServer -Server $server
    }
}

#Get the config from the JSON File
Function Get-480Config([string] $config_path)
{
    $conf=$null
    if(Test-Path $config_path)
    {
        $conf = (Get-Content -Raw -Path $config_path | ConvertFrom-Json)
        $msg = "Using Configuration at {0}" -f $config_path
        Write-Host -ForegroundColor "Green" $msg
    } else
    {
        Write-Host -ForegroundColor "Yellow" "No Configuration"
    }
    return $conf
}

#Select a VM to use
Function Select-VM([string] $folder)
{
    $selected_vm=$null
    try 
    {
        $vms = Get-VM -Location $folder
        $index = 1
        $agg = 0
        $spec = 0
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name 
            $index+=1
            $agg+=1
        }   
        while($spec -ne 1)
        {
            $pick_index = Read-Host "Which index numer [x] do you wish to pick?"
            if($pick_index -gt $agg)
            {
                Write-Host -ForegroundColor "Yellow" "Chosen index was not in the correct range. Select a valid index."
            }
            else 
            {
                $selected_vm = $vms[$pick_index -1]
                Write-Host -ForegroundColor "Green" "You picked" $selected_vm.name
                return $selected_vm 
                $spec+=1
            }
        }
    }
    catch 
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor Red    
    }
}

#Obtain the snapshot to create the clone with
Function Select-Snapshot([string] $snap_name, [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl] $selected_vm)
{
    $snapshot=$null
    try
    {
        $snapshot = Get-Snapshot -VM $selected_vm -Name $snap_name
        Write-Host -ForegroundColor "Green" "Snapshot has been successfully selected." 
        return $snapshot
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Invalid Snapshot or VM Selected"
        Exit
    }
}

#Obtain the VMWare Host to use
Function Select-VMWareHost([string] $hostName)
{
    $VMHost=$null
    try 
    {
        $VMHost = Get-VMHost -Name $hostName
        Write-Host -ForegroundColor "Green" "VM Host has been successfully identified."
        return $VMHost
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to identify VMHost."
        Exit
    }
}

#Identify the datastore you would like to use
Function Select-Datastore([string] $dstoreName)
{
    $datastore=$null
    try 
    {
        $datastore = Get-DataStore -Name $dstoreName
        Write-Host -ForegroundColor "Green" "Successfully selected datastore."
        return $datastore
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to select Datastore."
        Exit
    }
}

#Create the linked vm
Function New-LinkedClone([string] $chosenName, [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl] $chosenVm, 
                            [VMware.VimAutomation.ViCore.Types.V1.VM.Snapshot] $chosenSnap,
                            [VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost] $chosenHost, 
                            [VMware.VimAutomation.ViCore.Types.V1.DatastoreManagement.Datastore] $chosenStore)
{
    $linkedVM=$null
    try 
    {
        $linkedVM = New-VM -LinkedClone -Name $chosenName -VM $chosenVm -ReferenceSnapshot $chosenSnap -VMHost $chosenHost -Datastore $chosenStore
        Write-Host -ForegroundColor "Green" "Successfully created your linked clone: $chosenName"
        return $linkedVM
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to create linked clone."
        Exit
    }

}

#Grab the IP of a new box
Function Get-IP([VMware.VimAutomation.ViCore.Impl.V1.Inventory.VirtualMachineImpl] $chosenVM)
{
    $networkOutput=$null
    try 
    {
        ($networkOutput = Get-VM -Name $chosenVM).Guest.IPAddress
        Write-Host -ForegroundColor "Green" "Network information was successfully grabbed."
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Network information was not found."
    }
}

#Create a new virtual network and portgroup
Function New-Network([VMware.VimAutomation.ViCore.Types.V1.Inventory.VMHost] $userHost)
{
    $switchName = Read-Host "What would you like to name your switch?"
    $groupName = Read-Host "What would you like to name your new port group?"
    $newSwitch=$null
    try
    {
        $newSwitch = New-VirtualSwitch -Name $switchName -VMHost $userHost
        Write-Host -ForegroundColor "Green" "Switch successfully created."
        New-VirtualPortGroup -VirtualSwitch $newSwitch -Name $groupName
        Write-Host -ForegroundColor "Green" "Port group successfully created."
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to create switch/port group."
    }    
}

#Start a VM
Function Start-ProperVM([string] $folder)
{
    $selected_vm=$null
    try 
    {
        $vms = Get-VM -Location $folder
        $index = 1
        $agg = 0
        $spec = 0
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name 
            $index+=1
            $agg+=1
        }   
        while($spec -ne 1)
        {
            $pick_index = Read-Host "Which index number [x] do you wish to pick?"
            if($pick_index -gt $agg)
            {
                Write-Host -ForegroundColor "Yellow" "Chosen index was not in the correct range. Select a valid index."
            }
            else 
            {
                $selected_vm = $vms[$pick_index -1]
                $spec+=1
            }
        }
    }
    catch 
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor Red    
    }
    try 
    {
        Start-VM -VM $selected_vm
        Write-Host -ForegroundColor "Green" "Successfully started your VM."
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to Start your VM."
    }
}

#Set the network adapter of a VM
Function Set-NetworkAdapterVM([string] $name)
{
    $selected_vm=$null
    try 
    {
        $vms = Get-VM -name $name
        $index = 1
        $agg = 0
        $spec = 0
        $selected_vm = Get-VM -name $name
        <#foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name 
            $index+=1
            $agg+=1
        }   
        while($spec -ne 1)
        {
            $pick_index = Read-Host "Which index number [x] do you wish to pick?"
            if($pick_index -gt $agg)
            {
                Write-Host -ForegroundColor "Yellow" "Chosen index was not in the correct range. Select a valid index."
            }
            else 
            {
            $selected_vm = $vms[$pick_index -1]
                $spec+=1
            }
        }#>
    }
    catch 
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor Red    
    }
    $adapterNum = Read-Host "Which adapter would you like to change:1, 2, or 3?"
    $networkname = Read-Host "What network would you like to change your adapter too?"
    $adapterName = "blank"
    try 
    {
        $adapterName = "Network Adapter " + $adapterNum
        Get-VM $selected_vm | Get-NetworkAdapter -Name $adapterName | Set-NetworkAdapter -NetworkName $networkname
        Write-Host -ForegroundColor "Green" "Successfully changed your adapter"
    }
    catch 
    {
        Write-Host -ForegroundColor "Red" "Failed to change your adapter"
    }
}