function function_TestScript
{
    $result = (bash -c  "ps -ef | grep -v grep | grep splunkd | wc -l") -gt 1
    return $result
}


function function_GetScript
{
    $service = (bash -c  "ps -ef | grep -v grep | grep splunkd | wc -l") -gt 1
    $result = if ($service)
    {
        "Splunk Deamon is running"
    }
    else 
    {
        "Splunk Deamon is not installed or not running"
    }

    return $result
}


function function_SetScript
{

    $downloadpath = "<setup .sh script - SAS token>"
    $Targetlocation = "/opt/_setup/splunkforwarder"
    $bashfile = "SplunkForwarder.sh"

    # create local dir
    if (!(test-path $Targetlocation)) 
    {
        New-Item -ItemType Directory -Path $Targetlocation | Out-Null
    }

    # download content if not present
    $download = $Targetlocation + "/" + $bashfile
    if (!(Test-Path $download)) {Invoke-WebRequest -Uri $downloadpath -UseBasicParsing -OutFile $download} 

     # test job
    if (Test-Path $download)
    {
        write-output "Downloaded content from  [$downloadpath]"
        write-output  "stored content to [$download]"

        # start setup
        Write-verbose ("Starting Script Execution ...")

	bash -c "chmod +x $download"

        bash -c "$download"

    } else {
        write-output  "Error download content from  [$downloadpath]"
        write-output  "Error storing content to [$download]"
    }
}
