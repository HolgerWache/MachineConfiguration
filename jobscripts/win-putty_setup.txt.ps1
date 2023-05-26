function function_TestScript
{
    # query if putty in the desired version is installed
    $result = try {Get-CimInstance -Class Win32_Product | where-object IdentifyingNumber -eq "{8CFE5E4E-970A-4380-A782-AF6E609574F1}"} catch {} 
    return $result
}


function function_GetScript
{
    $getstate = try {Get-CimInstance -Class Win32_Product | where-object IdentifyingNumber -eq "{8CFE5E4E-970A-4380-A782-AF6E609574F1}"} catch {} 
    $result = if ($getstate)
    {
        Write-Output ('PuTTY release 0.76 is installed!')
    }
    else {
        Write-Output ('PuTTY release 0.76 is not installed')
    }

    return $result
}


function function_SetScript
{
    $downloadpath = "<Putty MSI - SAS Token>"
    $Targetlocation = "$Env:SystemDrive\_setup\"
    $Installfile = "putty-0.76-installer.msi"

    # create local dir
    if (!(test-path $Targetlocation)) 
    {
        New-Item -ItemType Directory -Path $Targetlocation | Out-Null
    }

    # download content if not present
    $download = $Targetlocation + $Installfile
    if (!(Test-Path $download)) {Invoke-WebRequest -Uri $downloadpath -UseBasicParsing -OutFile $download} 
    # test job
    if (Test-Path $download)
    {
        write-verbose -Message "Downloaded content from  [$downloadpath]"
        write-verbose -Message "stored content to [$download]"

        # start setup
        Write-verbose ("Starting Installation..")
        msiexec.exe /i $download /qn

    } else {
        write-verbose -Message "Error download content from  [$downloadpath]"
        write-verbose -Message "Error storing content to [$download]"
    }
}
