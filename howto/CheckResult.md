**Steps** <br /> 
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 1 [Prepare Environment](./Prepare.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 2 [Create Policy](./CreatePolicy.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 3 [Create and Store Job Script](./CreateJobScript.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 4 [Policy Assignment](./PolicyAssignment.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _--> Step 5 [Check Results]_ <br />

***

<br />  <br />

### Check the Result <br />
There are some ways to check the result
<br />

<details><summary>Azure Policy -- CLICK ME</summary>
  <p>

  Navigate to Azure Policy <br />

  ![](../pics/policycompliance.png)
  <br /><br />

  ***

  ![](../pics/policycompliancepolicies.png)
  <br /><br />

  ***

  ![](../pics/policyrescompliance.png)
  <br /><br />

  ***

  ![](../pics/policyrescomplianceoverview.png)
  <br />

  This screenshot show that the JobScript cannot be downloaded, in this case due to an expired token  <br />  

  ***

  ![](../pics/policyrescomplianceoverview2.png)
  <br />

  </p>
</details>

<details><summary>Workbook -- CLICK ME</summary>
  <p>
    
  I created a Azure Workbook visualizing Guest policies results and much more from data stored in ARG. <br />
  Focus is on Azure and Arc connected machines <br /><br />
  _Download the code from MDC GitHub and import it in your Azure environment_ <br />
  _https://github.com/Azure/Microsoft-Defender-for-Cloud/tree/main/Workbooks/GuestConfiguration%20Result_ <br />

  ![](../pics/Workbook5.png)
  
  ***
    
  ![](../pics/Workbook1.png)
  <br /><br />

  ***

  ![](../pics/Workbook2.png)
  <br /><br />

  ***

  ![](../pics/Workbook3.png)
  <br /><br />

  ***

  ![](../pics/Workbook4.png)
  <br /><br />
 
  </p>
</details>

<details><summary>Defender for Cloud - GUI -- CLICK ME</summary>
  <p>

  ![](../pics/MDC01.png)
  
  ***

  ![](../pics/MDC02.png)

  ***

  ![](../pics/MDC03.png)

  ***

  ![](../pics/MDC04.png)
  
  

  </p>
</details>

<details><summary>Defender for Cloud Recommendation - Azure Resource Graph -- CLICK ME</summary>
  <p>

  ![](../pics/RecARG1.png)

  ***

  ![](../pics/RecARG2.png)

  </p>
</details>

<details><summary>Defender for Cloud Recommendation - Log Analytics Continuous Export -- CLICK ME</summary>
  <p>
    
  You can export recommendation including timestamp of a state change to a Log Analytics workspace or Event Hub. <br /><br />
  _Continuously export Microsoft Defender for Cloud data_ <br />
  _https://learn.microsoft.com/en-us/azure/defender-for-cloud/continuous-export_ <br />

   ![](../pics/RecLAW.png)

  </p>
</details>

<details><summary>Azure Resource Graph -- CLICK ME</summary>
  <p>
  
  Navigate to Azure Resource Graph Explorer <br />
  
  ![](../pics/ARG.png)
  
  ***
    
  ![](../pics/ARGdetails.png)
  <br /><br />

  </p>
</details>

<details><summary>REST API -- CLICK ME</summary>
  <p>
    
  _Azure Policy Guest Configuration REST API Reference_ <br />
  _https://learn.microsoft.com/en-us/rest/api/guestconfiguration/_ <br /><br />

  _Microsoft Defender for Cloud_ <br />
  _https://learn.microsoft.com/en-us/rest/api/defenderforcloud/_ <br /><br />

   ![](../pics/REST01.png)

  ***

  ![](../pics/REST02.png)
    
  </p>
</details>


<details><summary>PowerShell -- CLICK ME</summary>
  <p>
    
  _PowerShell Az.Resources | Policy_ <br />
  _https://learn.microsoft.com/en-us/powershell/module/az.resources/?view=azps-9.4.0#policy_ <br /><br />

  _PowerShell Az.PolicyInsights | Policy Insights_ <br />
  _https://learn.microsoft.com/en-us/powershell/module/az.policyinsights/?view=azps-9.4.0#policy-insights_ <br /><br />
    
  _PowerShell Az.Security | Security_ <br />
  _https://learn.microsoft.com/en-us/powershell/module/az.security/?view=azps-9.4.0#security_ <br /><br />

   ![](../pics/powershell-azpolicy.png)

  ***

  ![](../pics/powershell-azpolicyresult.png)
    
  </p>
</details>


