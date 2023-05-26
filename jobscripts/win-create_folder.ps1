function function_TestScript
{
    $result = Test-Path "c:/FolderSetupWIN01"
    return $result
}

function function_GetScript
{
    $folder = "c:/FolderSetupWIN01"
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
    new-item -ItemType Directory -path "c:/FolderSetupWIN01"
}