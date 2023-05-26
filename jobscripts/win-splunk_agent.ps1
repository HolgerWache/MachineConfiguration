function function_TestScript
{

    # verify config package for splunk connection
    $setupdir = $env:SystemDrive + "\_setup\splunk"
    $BlobConfig = "splunkforwarder_config.zip" 
    $configpackage = if (test-path $setupdir\$BlobConfig) {Get-Item $setupdir\$BlobConfig}
    $configpackagetmp = try{(($configpackage[0].name).split(".")[0]) } catch {}

    # define service 
    $service = @{}
    $service.Add('Name','SplunkForwarder')
    $service.Add('StartupType','Automatic')
    $service.Add('BuiltInAccount','LocalSystem')
    $service.Add('Status','Running')
    $log = $null
    $log = @()
    $output = $null
    $count = $null
    
    # get service
    $servicestatus = Get-Service -Name $service.name -ErrorAction SilentlyContinue
    
        
    # check states
    $result = $true
    if (!($servicestatus.StartType -eq $service.StartupType)) {$result = $null}
    if (!($servicestatus.Status -eq $service.Status)) {$result = $null}
    if (!((Get-CimInstance -ClassName Win32_Service | where Name -eq $service.name).startname -eq $service.BuiltInAccount)) {$result = $null}
    
    # verify whether is has run already or there was a new setup at this run
    if (!(Get-Content $setupdir\splunkforwarder_config.log -ErrorAction SilentlyContinue) -eq $configpackagetmp) {$result = $null}
    if (!($configpackagetmp)) {$result = $null}

    
    return $result
}


function function_GetScript
{
    # verify config package for splunk connection
    $setupdir = $env:SystemDrive + "\_setup\splunk"
    $BlobConfig = "splunkforwarder_config.zip" 
    $configpackage = if (test-path $setupdir\$BlobConfig) {Get-Item $setupdir\$BlobConfig}
    $configpackagetmp = try{(($configpackage[0].name).split(".")[0]) } catch {}

    # define service 
    $service = @{}
    $service.Add('Name','SplunkForwarder')
    $service.Add('StartupType','Automatic')
    $service.Add('BuiltInAccount','LocalSystem')
    $service.Add('Status','Running')
    $log = $null
    $log = @()
    $output = $null
    $count = $null
    
    # get service
    $servicestatus = Get-Service -Name $service.name -ErrorAction SilentlyContinue
    $serviceaccount = (Get-CimInstance -ClassName Win32_Service | where Name -eq $service.name).startname
    $configpackage = Get-Content $setupdir\splunkforwarder_config.log -ErrorAction SilentlyContinue
    
    $result = "Servicename: {0} `r`nStartupType: Actual [{1}] | Expected [{2}] `r`nAccount: Actual [{3}] | Expected [{4}] `r`nState: Actual [{5}] | Expected [{6}] `r`nconfigpackage: Actual [{7}] | Expected [{8}] `
                " -f $service.Name, $servicestatus.StartType, $service.StartupType, $serviceaccount, $service.BuiltInAccount, $servicestatus.Status , $service.Status, $configpackagetmp, $configpackage 


  
    return $result
}


function function_SetScript
{
    # variable for download
    $StorageAccountName = "<storage account name>"
    $Container = "install"
    $Blob = "splunkforwarder.msi"
    $BlobConfig = "splunkforwarder_config.zip" 
    $SASToken = "<MSI SAS Token>"
    $SASTokenConfig = "<Config file SAS Token>"
    $setupdir = $env:SystemDrive + "\_setup\splunk"

    # variable for ClientName config directive
    $dcconf = $env:ProgramFiles + "\SplunkUniversalForwarder\etc\system\local\deploymentclient.conf"

    # variable for config package setup
    $splunkdir = $env:ProgramFiles+"\SplunkUniversalForwarder"


    $service = @{}
    $service.Add('Name','SplunkForwarder')
    $service.Add('StartupType','Automatic')
    $service.Add('BuiltInAccount','LocalSystem')
    $service.Add('Status','Running')
    $log = $null
    $log = @()
    $output = $null
    $count = $null


    # get service
    $servicestatus = Get-Service -Name $service.name -ErrorAction SilentlyContinue

    # verify setupdir and create it
    if (!(test-path $setupdir)) {new-item -ItemType Directory -Path $setupdir}

    # verify service install state and run setup if required
    if (!($servicestatus)) 
    {
        # download 
        if (!(test-path $($setupdir+"\"+$blob))) {Invoke-WebRequest -Uri "https://$StorageAccountName.blob.core.windows.net/$Container/$($Blob)$($SASToken)" -OutFile "$setupdir\$Blob"}

        # MSI install
        msiexec.exe /i "$setupdir\$Blob" DEPLOYMENT_SERVER="<deployment server>" SPLUNKUSERNAME="<username>" GENRANDOMPASSWORD="<setting>" AGREETOLICENSE=Yes REBOOT=R /l*v $setupdir\splunkforwarder.log /qn

        # log
        $log += "MSI setup = done"

        # load service status
        $count = $null
        while (!($servicestatus = Get-Service -Name $service.name -ErrorAction SilentlyContinue))
        {
            start-sleep -Seconds 5
            $count++ 
            if ($count -ge 24) 
            {
                $log += "service not found after setup " + $service.name
                break
            }

        }

    }
    else
    {
        $log += "software installed, skip setup"
    }


    # verify service startup type and correct it
    if (!($servicestatus.StartType -eq $service.StartupType))
    {
        # correct service startup
        Set-Service -Name $service.Name -StartupType $service.StartupType 

        # verify action
        if (((get-service -Name $service.name).StartType) -eq $service.StartupType)
        {
            #log
            $log += "corrected startuptype to " + $service.StartupType
        }
        else
        {
            #log
            $log += "error correcting startuptype to " + $service.StartupType
        }
    }
    else
    {
        #log
        $log += "OK startuptype " + $service.StartupType

    }


    # verify service status and correct it
    if (!($servicestatus.Status -eq $service.Status))
    {
        # correct service startup
        Set-Service -Name $service.Name -Status $service.Status -WarningAction SilentlyContinue

        # verify action
        if (((get-service -Name $service.name).Status) -eq $service.Status)
        {
            #log
            $log += "corrected status to " + $service.status
        }
        else
        {
            #log
            $log += "error correcting stats to " + $service.Status
        }
    }
    else
    {
        #log
        $log += "OK status " + $service.status

    }


    # verify service account
    if (!((Get-CimInstance -ClassName Win32_Service  | where Name -eq $service.name).startname -eq $service.BuiltInAccount))
    {
        #log
        $log += "correct manually, service runs as " + (Get-CimInstance -ClassName Win32_Service  | where Name -eq $service.name).startname
    }
    else
    {
        #log
        $log += "OK service account " + (Get-CimInstance -ClassName Win32_Service  | where Name -eq $service.name).startname
    }



    # Add clientName configuration directive

    if (!( test-path $($dcconf) ))
    {
        Add-Content -Path $dcconf -Value '[deployment-client]'
	    Add-Content -Path $dcconf -Value 'clientName = <clientname>'
	    $log += "Auto-Onboarding config installed and deploymentclient.conf created."
    }
    else
    {
	    if ( (Get-Content $dcconf | Select-String -Pattern 'clientName' ).Matches.Success )
	    {
		    $log += "Auto-Onboarding config already present, not touching."
	    } else {
		    Add-Content -Path $dcconf -Value '[deployment-client]'
		    Add-Content -Path $dcconf -Value 'clientName = <clientname>'
		    $log += "Auto-Onboarding config installed."
	    }
    }

    

    # download 
    if (!(test-path $($setupdir+"\"+$BlobConfig))) {Invoke-WebRequest -Uri "https://$StorageAccountName.blob.core.windows.net/$Container/$($BlobConfig)$($SASTokenConfig)" -OutFile "$setupdir\$BlobConfig"}


    # install config package for splunk connection
    $configpackage = Get-Item $setupdir\$BlobConfig
    $configpackagetmp = (($configpackage[0].name).split(".")[0]) 

    # verify whether is has run already or there was a new setup at this run
    if (!((Get-Content $setupdir\splunkforwarder_config.log -ErrorAction SilentlyContinue) -eq $configpackagetmp) -or $count )

    {
        # extract zip  
        # Expand-Archive $configpackage[0] -DestinationPath $setupdir\$configpackagetmp
        # Expand-Archive is not available in Srv2012, PS4

        Add-Type -assembly 'system.io.compression.filesystem'
        [io.compression.zipfile]::ExtractToDirectory($configpackage[0],"$setupdir\$configpackagetmp")


        # get file to copy
        $items = Get-childItem $setupdir\$configpackagetmp -Recurse | where mode -Match "-a---"

        # copy files to splunk directory
        foreach ($item in $items)
        {
            $target = -join ($splunkdir, $item.directoryname.Replace("$($setupdir)\$($configpackagetmp)",""))
            if (!(test-path $target)) {New-Item -ItemType Directory $target | Out-Null}
            Copy-Item -Path $item.FullName $target -Force
        }

        # delete configpackage temp
        remove-item -Path $setupdir\$configpackagetmp\* -Recurse -Force -Confirm:$false
        remove-item -Path $setupdir\$configpackagetmp\ -Force -Confirm:$false

        # write package details to a log
        $configpackagetmp | out-file $setupdir\splunkforwarder_config.log

        # stop service and set to configured state to read new config
        Set-Service -Name $service.Name -Status Stopped -WarningAction SilentlyContinue
        Set-Service -Name $service.Name -Status $service.Status -WarningAction SilentlyContinue
    
        # log
        $log += "just installed config package " + $configpackagetmp
    }
    else
    {
        $log += "configpackage installed already " + $configpackagetmp 
    }


    # log output
    foreach ($entry in $log)
    {
        $output = $output + $entry + ";"
    }

    write-host $output.TrimEnd(";") 

}

