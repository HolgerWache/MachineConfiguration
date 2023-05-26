**Steps** <br /> 
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 1 [Prepare Environment](./Prepare.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 2 [Create Policy](./CreatePolicy.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 3 [Create and Store Job Script](./CreateJobScript.md)_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _--> Step 4 [Policy Assignment]_ <br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 5 [Check Results](./CheckResult.md)_ <br />

***

<br />  <br />

### Azure VM Prerequesites <br />
as mentioned on the _[Prepare Environment](./Prepare.md)_ site, we need to install the AzurePolicy extension with a managed identity on Azure VMs. You can ignore both settings for Arc machines. Either deploy it manually on each VM, or assign the following built-in policy initiative that is present in the system already.


 **_Deploy prerequisites to enable Guest Configuration policies on virtual machines_** <br />

<br />  

Verify the extension and managed identity is installed. If the policy is assigned to existing VMs, a remediation is required to deploy the resources. Newly created VMs should get the settings applied by the policy within 15 minutes.

<br />  <br />

### Policy Assignment <br />
The policy definitions can be assigned directly, but I want the results also visible as Recommendation in _Microsoft Defender for Cloud_. Therefore we need to create an initiative and assign these.
<br /><br />

**Create Initiative** <br />
![](../pics/initiativecreate.png)
<br /><br />

***

![](../pics/initiativebasics.png)
<br /><br />

***

![](../pics/initiativegroups.png)
<br /><br />

***

![](../pics/initiativepolicies.png)
<br /><br />

***

![](../pics/initiativepolicies2.png)
<br />

Select Group and Click Save <br />

***

Set the parameters <br />
  - Include Arc machines in case you want treat them like Azure VMs <br />
  - Select the Local path for the jobscript, Default is the Windows version, for Linux adjust it <br />
  - Local PowerShell Script Name --> put in the ScriptName.ps1 <br />
  - Web PowerShell Script --> put in the SAS URI  <br />

![](../pics/initiativeparameter.png)
<br />

***

![](../pics/initiativesaved.png)
<br /><br />

**Assign the Initiative** <br />
if you don't want the results in Microsoft Defender for Cloud, do the assignment in Azure Policy. <br />
go to _Microsoft Defender for Cloud_

![](../pics/mdcenvsettings.png)
<br />

Select the Subscription of MGMT Group where the assignment should be done <br />

***

![](../pics/mdcaddcustominitative.png)
<br /><br />

***

![](../pics/mdcaddcustominitative2.png)
<br /><br />

***

![](../pics/mdcaddcustominitativebasics.png)
<br /><br />

***

![](../pics/mdcaddcustominitativeidentity.png)
<br />

Change the Identity location if required <br />
Click Review + create and Create <br />
<br />

This needs now some time for the machines to evaluate the policy. <br />
Currently we have not triggered a remediation, we need the result first. At this moment we're in Audit only mode. <br />
The assignment gives the possibility to remediate but only a single policy.
New VMs, created after the initiative assignment was done, are remediated automatically.
<br /><br />

**Trigger a Remediation Task** <br />
Once the policy has evaluated and finds noncompliant results we can start the remediation <br />

![](../pics/mdcaddcustominitativerem.png)
<br /><br />

***

![](../pics/mdcaddcustominitativeremtask.png)
<br /><br />

***
<br />

**Congratulations, you have done the whole job :relaxed:** <br />
You have deployed custom Machine Configuration policies and assigned it with a jobscript. <br />
Now you are ready to extend the solution by simply upload additional jobscripts and assign it with the existing policies.
<br /> <br />
The evaluation and report creation need some time.  <br />
Relax, take your time, fill up your coffee :coffee:  <br />
Don't forget to follow the last link and check your results 

<br /><br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;  _Step 5 [Check Results](./CheckResult.md)_ <br />
