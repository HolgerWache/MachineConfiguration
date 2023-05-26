function function_TestScript
{
    $result = Test-Path "/opt/FolderSetupUX01"
    return $result
}

function function_GetScript
{
    $folder = "/opt/FolderSetupUX01"
    $foldercheck = Test-Path $folder
    $result = if (Test-Path $folder)
    {
        "Folder {0} is present" -f $folder
    }
    else {
        "Folder {0} is not present" -f $folder
    }
    return $result
}

function function_SetScript
{
    new-item -ItemType Directory -path "/opt/FolderSetupUX01"
}