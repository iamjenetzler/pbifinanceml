# pbifinanceml

## Hackathon Setup

This repo includes the materials needed to set up and execute the Power BI Finance ML workshop. Use the PowerShell scripts to create the hacker user accounts, assign licenses, create a workspace for each hacker, assign the workspaces to dedicated capacity, and add the hackers as contributors to their own workspace. The repo also includes the data file and the hackathon step-by-step guide for the hackers.

### Prerequisites

- Create a [CDX Environment](https://cdx.transform.microsoft.com)
  - Go to "My Environments" tab
  - Click on "Create Tenant"
  - Select the following options: Microsoft 365 Enterprise Demo Content, Quick Tenant, 90 days
- Set up an Azure subscription (Embedded Capacity option)
  - Sign into Azure portal with tenant admin account
  - Use a voucher to create a new subscription. Process to redeem an Azure Pass voucher: https://www.microsoftazurepass.com/Home/HowTo
  - Create a [Power BI Embedded](https://docs.microsoft.com/en-us/power-bi/developer/embedded/embedded-capacity?tabs=gen2#sku-memory-and-computing-power") resource in the subscription
- Set up Power BI dedicated capacity (Premium per User option)
  - Log into [Power BI]([https://www.powerbi.com](https://app.powerbi.com/home) with Admin account
  - Sign up for Power BI when prompted 
  - Sign up for 60 day free trial Premium per User

### Hackathon User Setup

- Set up users in O365 [(PowerShell script)](../../blob/main/setup/o365users.ps1)
  - Revoke O365 licenses from environment's user accounts
  - Create hackathon users
  - Assign hackathon users O365 E5 licenses
- Set up users in Power BI [(PowerShell script)](../../blob/main/setup/pbisetup.ps1)
  - Create a workspace for each hackathon user
  - Assign dedicated capacity to workspaces
  - Assign hackathon user as contributor to workspace (1:1)
  - NB: this script needs to be run using -NoProfile (From cmd, Powershell.exe -NoProfile -File)
