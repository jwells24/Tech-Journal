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
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name 
            $index+=1
        }   
        $pick_index = Read-Host "Which index numer [x] do you wish to pick?"
        # Deal with an invalid index
        $selected_vm = $vms[$pick_index -1]
        Write-Host "You picked" $selected_vm.name
        return $selected_vm 
    }
    catch 
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor Red    
    }
}

#
