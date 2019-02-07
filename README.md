# Azure Infrastructure for ASC LAB 
**Author** [Franck D. - Digital Archeology](https://aka.ms/mcra)

**This repository is currently in preview. PowerShell scripts and ARM templates are still in development, do not use them in production!**

# Content
This repository contains PowerShell script that are used to automatically deploy an Azure hands-on lab environment.

1. [Prerequisites](https://github.com/digitalarche/ASC-Lab101#prerequisites)
2. [Background information](https://github.com/digitalarche/ASC-Lab101#background-information)
3. [Initial lab deployment](https://github.com/digitalarche/ASC-Lab101#initial-lab-deployment)

## Prerequisites
To be able to attend the workshop and complete all hands-on demos, a valid Azure subscription is required. 

- A valid subscription to Azure. If you don't currently have a subscription, consider setting up a free trial. [here](https://azure.microsoft.com/en-us/free/).
  If this workshop is being hosted by a Microsoft Cloud Solution Architect, Azure passes should be provided.

- Multiple browser windows will be required to log in as different users simultaneously.

- A mobile phone, used to respond to multi-factor authentication challenges. ** Not for 101 but for 102 & 103

## Background information
In this one-day workshop you will learn how to securely deploy Azure infrastructure solutions. We will cover the following topics:
* Azure Security Center
* Virtual Machines
* Azure Networking
* JIT
* Azure Storage
* Azure SQL
* Playbook
* RBAC     ** Little waiting 201
* Governance ** Little waiting 201 
* DevOps - AzSk ** Little waiting 301
* Policy And ASC Deployment - Scale CI/CD ** Little waiting 301

## Initial lab deployment
All user names and password for the environment are set to **labuser / and yours ;) **.

**1.** Login to [Azure Portal](https://portal.azure.com) with an account that has administrative permissions on an active Azure subscription.

**2.** Open a Cloud Shell window using the “>_”  on the top right hand side of the screen.

**3.** Make sure the Cloud Shell window is set to “Powershell” (not “Bash”) as shown in Figure 3.

```powershell
$script = Invoke-WebRequest https://raw.githubusercontent.com/digitalarche/ASC-Lab101/master/Asclabdeploy.ps1 -UseBasicParsing
Invoke-Expression $($script.Content)
```
The deployment takes up to 20 minutes. After the deployment has finished you will be informed in the PowerShell windows.