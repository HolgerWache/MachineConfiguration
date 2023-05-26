function function_TestScript
{
    $result = try {(Get-Service -Name xagt -ErrorAction SilentlyContinue).Status  -eq "Running"  } catch {} 
    return $result
}


function function_GetScript
{
    $getstate = try {(Get-Service -Name xagt -ErrorAction SilentlyContinue).Status  -eq "Running"  } catch {} 
    $result = if ($getstate)
    {
        Write-Output ('FireEye already installed!')
    }
    else {
        Write-Output ('FireEye not installed or not running!')
    }

    return $result
}


function function_SetScript
{
    $downloads = @( `
        "<Installer SAS Token>", `
        "<Config file SAS Token>" `
        )
    $Targetlocation = "$Env:SystemDrive\_setup\"
    $Installfile = "xagtSetup_xxx.msi"

  # create local dir
    if (!(test-path $Targetlocation)) 
    {
        New-Item -ItemType Directory -Path $Targetlocation | Out-Null
    }

    # download and check loop 
    foreach ($download in $downloads)
    {
        # download content if not present
        $filepath = $null
        $file = $null
        $file = ($download.split("?")[0]).split("/")[($download.split("?")[0]).split("/").count -1] 
        $filepath = $Targetlocation + $file
        if (!(Test-Path $filepath)) {Invoke-WebRequest -Uri $download -UseBasicParsing -OutFile $filepath}
        
         # test job
        if (Test-Path $filepath)
        {
            write-verbose -Message "Downloaded content from [$download]"
            write-verbose -Message "stored content to [$filepath]"
        } 
        else 
        {
            write-verbose -Message "Error download content from [$download]"
            write-verbose -Message "Error storing content to [$filepath]"
        } 
    } 

  
    #setup
   
    Write-verbose ("Starting Installation..")
    msiexec.exe /i "$TargetLocation\$Installfile" CONFJSONDIR="$TargetLocation" /qn

    Write-verbose ("Starting Service")
    
    $j = 1
    while ($j -lt 600)
    {
        $service = try {Get-Service -Name xagt -ErrorAction SilentlyContinue } catch {}
        if ($service) {break}
        $j++
        Start-Sleep -Milliseconds 100
    }

    Start-Sleep -Seconds 3

    Start-Service -Name xagt

    if($(Get-Service -Name xagt).Status  -eq "Running" ) {
        Write-verbose ("FireEye installation completed.")
    }
    else {
        Write-verbose ("Error! FireEye installation failed.")
    }
}
