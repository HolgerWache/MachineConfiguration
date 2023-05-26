**Steps** <br /> 
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 1 [Prepare Environment](./Prepare.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _--> Step 2 [Create Policy]_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 3 [Create and Store Job Script](./CreateJobScript.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 4 [Policy Assignment](./PolicyAssignment.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 5 [Check Results](./CheckResult.md)_ <br />

***

<br />  <br />

### Create Configuration and Package

Create a working folder for the first windows policy, Linux works exactly the same way by only changing a parameter (see below) <br />
e.g. GC4.3.0_Win

Change folder dir in PowerShell
```powershell
cd GC4.3.0_Win
```
<br />

place the configuration file in working folder <br />
_GC4.3.0_Win\configuration.ps1_

```powershell
Configuration CustomScript
{
    param (
        
    )

    Import-DscResource -ModuleName ComPSScriptWinUX
    Node localhost
    {
        ComPSScriptWinUX PowershellScript
        {
            webpsscript        = "empty" 
            localscript        = "empty"
            localpath          = "empty"
        }
    }
}

CustomScript -OutputPath: ".\output"
```
<br />



**execute configuration**
```powershell
.\configuration.ps1
```
A folder output is created with localhost.mof file
<br />

**place the parameter file in working folder <br />**
_GC4.3.0_Win\parameter.ps1_
```powershell
# define parameters
$PolicyParameterInfo = @(
    @{
      Name = 'localpath'                                           # Policy parameter name (mandatory)
      DisplayName = 'Local path to PowerShell Script'                          # Policy parameter display name (mandatory)
      Description = 'Local path to PowerShell Script, e.g. $Env:SystemDrive\\_setup\\'     # Policy parameter description (optional)
      ResourceType = 'ComPSScriptWinUX'                                       # DSC configuration resource type (mandatory)
      ResourceId = 'PowershellScript'                         # DSC configuration resource id (mandatory)
      ResourcePropertyName = 'localpath'                                  # DSC configuration resource property name (mandatory)
      ResourcePropertyValue = '$Env:SystemDrive\_setup\'              # required for local testing
      DefaultValue = '$Env:SystemDrive\\_setup\\'                   # Policy parameter default value (optional)
      AllowedValues = @('$Env:SystemDrive\\_setup\\','/opt/_setup')                   # Policy parameter allowed values (optional)
    },
    @{
      Name = 'localscript'                                           # Policy parameter name (mandatory)
      DisplayName = 'Local PowerShell Scriptname'                          # Policy parameter display name (mandatory)
      Description = 'Local name of PowerShell Script, e.g. custom.ps1'     # Policy parameter description (optional)
      ResourceType = 'ComPSScriptWinUX'                                       # DSC configuration resource type (mandatory)
      ResourceId = 'PowershellScript'                         # DSC configuration resource id (mandatory)
      ResourcePropertyName = 'localscript'                                  # DSC configuration resource property name (mandatory)
      ResourcePropertyValue = 'FolderSetupWIN02.ps1'
    },
    @{
      Name = 'webpsscript'                                           # Policy parameter name (mandatory)
      DisplayName = 'Web PowerShell Script'                          # Policy parameter display name (mandatory)
      Description = 'Path to PowerShell Script, e.g. https://customurl/script.ps1?sastoken'     # Policy parameter description (optional)
      ResourceType = 'ComPSScriptWinUX'                                       # DSC configuration resource type (mandatory)
      ResourceId = 'PowershellScript'                         # DSC configuration resource id (mandatory)
      ResourcePropertyName = 'webpsscript'                                  # DSC configuration resource property name (mandatory)
      ResourcePropertyValue = 'https://airsazurepolicy.blob.core.windows.net/scripts-gc-v4-2/FolderSetupWIN02.ps1?sp=r&st=2023-01-23T15:36:07Z&se=2023-01-23T23:36:07Z&spr=https&sv=2021-06-08&sr=b&sig=5tvqnZSucFnBWWthQTPO9vTK2SBEEDiJDNrQ2fS6T%2FA%3D'
    }
  )
```
 <br />
 
 Execute/load parameter (its dot space dot, verify the result by calling the variable $PolicyParameterInfo)

 ```powershell
PS C:\Users\holger\Desktop\GC4.3.0_Win> . .\parameter.ps1

PS C:\Users\holger\Desktop\GC4.3.0_Win> $PolicyParameterInfo

Name                           Value                                                                                                                                                
----                           -----                                                                                                                                                
ResourceId                     PowershellScript                                                                                                                                     
Description                    Local path to PowerShell Script, e.g. $Env:SystemDrive\\_setup\\                                                                                     
DefaultValue                   $Env:SystemDrive\\_setup\\                                                                                                                           
AllowedValues                  {$Env:SystemDrive\\_setup\\, /opt/_setup}                                                                                                            
ResourceType                   ComPSScriptWinUX                                                                                                                                     
Name                           localpath                                                                                                                                            
ResourcePropertyValue          $Env:SystemDrive\_setup\                                                                                                                             
ResourcePropertyName           localpath                                                                                                                                            
DisplayName                    Local path to PowerShell Script                                                                                                                      
ResourceId                     PowershellScript                                                                                                                                     
Name                           localscript                                                                                                                                          
Description                    Local name of PowerShell Script, e.g. custom.ps1                                                                                                     
ResourceType                   ComPSScriptWinUX                                                                                                                                     
ResourcePropertyName           localscript                                                                                                                                          
ResourcePropertyValue          jobscript.ps1                                                                                                                                        
DisplayName                    Local PowerShell Scriptname                                                                                                                          
ResourceId                     PowershellScript                                                                                                                                     
Name                           webpsscript                                                                                                                                          
Description                    Path to PowerShell Script, e.g. https://customurl/script.ps1?sastoken                                                                                
ResourceType                   ComPSScriptWinUX                                                                                                                                     
ResourcePropertyName           webpsscript                                                                                                                                          
ResourcePropertyValue          https://airsazurepolicy.blob.core.windows.net/blobcontainer/jobscript.ps1                                                                            
DisplayName                    Web PowerShell Script      

 ```
 <br />
 
** Define a name for the policy, e.g**
 ```powershell
 $policyname = "GC.4.3.0_WinCustomScript"
  ```
  <br />
  
**Create a GuestConfiguration Package**

```powershell
New-GuestConfigurationPackage `
  -Force `
  -name $policyname `
  -Configuration .\output\localhost.mof  `
  -Path .\  `
  -Verbose `
  -Type AuditAndSet
  ```
  <br />
  
output drops a zip packages

```powershell
PS C:\Users\holger\Desktop\GC4.3.0_Win> New-GuestConfigurationPackage `
  -Force `
  -name $policyname `
  -Configuration .\output\localhost.mof  `
  -Path .\  `
  -Verbose `
  -Type AuditAndSet
VERBOSE: Starting New-GuestConfigurationPackage
VERBOSE: Found resource dependency in mof with instance name '' and resource name 'ComPSScriptWinUX' from module 'ComPSScriptWinUX' with version '0.1.0'.
VERBOSE: Found 1 resource dependencies in the mof.
VERBOSE: Searching for a module with the name 'ComPSScriptWinUX' and version '0.1.0'...
VERBOSE: Loading module from path 'C:\Program Files\WindowsPowerShell\Modules\ComPSScriptWinUX\ComPSScriptWinUX.psm1'.
VERBOSE: Found the module dependencies: ComPSScriptWinUX
VERBOSE: Creating the package root folder at the path 'C:\Program Files\WindowsPowerShell\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4.3.0_WinCustomScript'...
VERBOSE: Creating the package Modules folder at the path 'C:\Program Files\WindowsPowerShell\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4.3.0_WinCustomScript\Modules'...
VERBOSE: Setting the content of the package metaconfig at the path 'C:\Program Files\WindowsPowerShell\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4.3.0_WinCustomScript\GC.4.3
.0_WinCustomScript.metaconfig.json'...
VERBOSE: Copying the compiled DSC configuration (.mof) from the path 'C:\Users\holger\Desktop\GC4.3.0_Win\output\localhost.mof' to the package path 'C:\Program Files\WindowsPowerShe
ll\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4.3.0_WinCustomScript\GC.4.3.0_WinCustomScript.mof'...
VERBOSE: Copying module from 'C:\Program Files\WindowsPowerShell\Modules\ComPSScriptWinUX' to 'C:\Program Files\WindowsPowerShell\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4
.3.0_WinCustomScript\Modules\ComPSScriptWinUX'
VERBOSE: Compressing the generated package from the path 'C:\Program Files\WindowsPowerShell\Modules\GuestConfiguration\4.3.0\gcworker\temp\GC.4.3.0_WinCustomScript' to the package 
path 'C:\Users\holger\Desktop\GC4.3.0_Win\GC.4.3.0_WinCustomScript.zip'...

Name                     Path                                                            
----                     ----                                                            
GC.4.3.0_WinCustomScript C:\Users\holger\Desktop\GC4.3.0_Win\GC.4.3.0_WinCustomScript.zip
 ```
  <br />
  
*Next steps are to upload the package and create/upload the policy. Both require a prior authentication against Azure in case we want to do it from the console. Without authentication from here you can upload the package to a https endpoint of your choice and upload the policy manually via the portal GUI*
 <br /><br />
 
**Authentication** <br />
Verify whether the required module is installed, otherwise you get this error "The term 'connect-AzAccount' is not recognized as the name of a cmdlet"

Check
```powershell
Get-Module az.accounts
```
Install
```powershell
Install-Module az.accounts
```
Connect
```powershell
connect-AzAccount
```
<br />

**Package Upload** <br />
Verify whether the required module is installed, otherwise you get this error "The command Get-AzStorageAccount is part of Azure PowerShell module "Az.Storage" and it is not installed."

Check
```powershell
Get-Module az.storage
```
Install
```powershell
Install-Module az.storage
```
<br />

Load the function for uploading the just crated zip package to a blob storage account.
Please adjust your Azure Subscription where your storage account is located (line 16) and SAS token lifetime (line 29)

<details><summary>publish Function -- CLICK ME</summary>
<p>

#### publish Function

```powershell
function publish {
    param(
    [Parameter(Mandatory=$true)]
    $resourceGroup,
    [Parameter(Mandatory=$true)]
    $storageAccountName,
    [Parameter(Mandatory=$true)]
    $storageContainerName,
    [Parameter(Mandatory=$true)]
    $filePath,
    [Parameter(Mandatory=$true)]
    $blobName
    )
    # change to subscripton and back --> at the end
    $currentsub = (get-azcontext).subscription.id
    Select-AzSubscription f918b18e-2490-497c-97c8-34e84b191761 | out-null
    # Get Storage Context
    $Context = Get-AzStorageAccount -ResourceGroupName $resourceGroup `
        -Name $storageAccountName | `
        ForEach-Object { $_.Context }
    # Upload file
    $Blob = Set-AzStorageBlobContent -Context $Context `
        -Container $storageContainerName `
        -File $filePath `
        -Blob $blobName `
        -Force
    # Get url with SAS token
    $StartTime = (Get-Date)
    $ExpiryTime = $StartTime.AddYears('10')  # TEN YEAR EXPIRATION
    $SAS = New-AzStorageBlobSASToken -Context $Context `
        -Container $storageContainerName `
        -Blob $blobName `
        -StartTime $StartTime `
        -ExpiryTime $ExpiryTime `
        -Permission rl `
        -FullUri
    # switch subscripton back to context that was before
    Select-AzSubscription $currentsub | Out-Null
    # Output
    return $SAS
}
```
</p>
</details>
<br />

Call the upload function.
Please adjust the parameters prior that fits to your storage account
```powershell
$uri = publish `
  -resourceGroup 'AIRS-Policy' `
  -storageAccountName 'airsazurepolicy' `
  -storageContainerName 'gcpolicies-v4-2' `
  -filePath (".\"+$policyname+".zip" ) `
  -blobName ($policyname+".zip") 
```
Verify the SAS token creation by calling the $uri variable
<br /><br />

**Generate Policy** <br />
The next step is the policy generation, change the Platform parameter to **"Linux"** if you create the Linux version. The result differs then when you look to the "if" statement of the created policy.
Upload the policy to Azure Policy


_Info:_
_The Mode parameter, defines whether this is an Audit, Apply or AutoCorrect Policy._ 
_Apply and AutoCorrect need a Remediation (on or after assignment) to be effective, if you don't trigger a remediation or disable the enforcement, the policy is Auditing only._
_https://learn.microsoft.com/en-us/azure/governance/machine-configuration/machine-configuration-policy-effects#machine-configuration-assignment-types_
<br />

```powershell
$policy = New-GuestConfigurationPolicy `
 -PolicyId (New-GUID) `
 -ContentUri $uri `
 -DisplayName $policyname `
 -Description 'Test policy with remediation option' `
 -Path '.\policyDefinitions' `
 -Platform 'Windows' `
 -PolicyVersion 1.0.0 `
 -Mode 'ApplyAndAutoCorrect' `
 -Parameter $PolicyParameterInfo `
 -Verbose
```

Verifiy the policy has been created  <br />
_policyDefinitions\GC.4.3.0_WinCustomScript_DeployIfNotExists.json_
<br /><br />

**Upload the policy to Azure Policy** <br />
Verify whether the required module is installed, otherwise you get this error "The command New-AzPolicyDefinition is part of Azure PowerShell module "Az.Resources" and it is not installed."

Check
```powershell
Get-Module az.resources
```
Install
```powershell
Install-Module az.resources
```
<br />

The policy must be stored on either a MGMT group or a subscription. <br />
_Consider, the assignment can only be done on the same or a deeper level!_

<br />

Subscription: <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Policy will be stored to the current context <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Verify: Get-AzContext <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Change: Set-AzContext "subscription" <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Upload: <br />
  ```powershell 
  New-AzPolicyDefinition -Name $policy.name -Policy $policy.path 
  ```
<br />

MGMT Group: <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Define the name of the MGMT Group, if you want to store the policy on the Tenant Root Group, provide the Tenant ID <br />
  &nbsp;&nbsp;&nbsp;&nbsp; Upload: <br />
  ```powershell 
  New-AzPolicyDefinition -Name $policy.name -Policy $policy.path -ManagementGroupName myTenantID 
  ```
<br />

Verify policy upload
![](../pics/policyazure.png)


<br /><br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Next: Step 3 [Create and Store Job Script](./CreateJobScript.md)_ <br />