# pbifinanceml

## Hackathon Setup

This repo includes the materials needed to set up and execute the Power BI Finance ML workshop. Use the PowerShell scripts to create the hacker user accounts, assign licenses, create a workspace for each hacker, assign the workspaces to dedicated capacity, and add the hackers as contributors to their own workspace. The repo also includes the data file and the hackathon step-by-step guide for the hackers.

### Prerequisites

- Create a [CDX Environment](https://cdx.transform.microsoft.com)
  - Go to "My Environments" tab
  - Click on "Create Tenant"
  - Select the following content pack: Microsoft 365 Enterprise
- Set up an Azure subscription
  - Sign into Azure portal with tenant admin account
  - Use a voucher to create a new subscription
  - Create a [Power BI Embedded](https://docs.microsoft.com/en-us/power-bi/developer/embedded/embedded-capacity?tabs=gen2#sku-memory-and-computing-power") resource in the subscription
- Set up Power BI dedicated capacity
  - Premium per User: sign up for free trial in the Power BI web application
  - Embedded: use the Power BI embedded resource you created in the Azure subscription

### Hackathon User Setup

- Set up users in O365 [(PowerShell)](../../blob/main/setup/o365users.ps1)
  - Revoke O365 licenses from environment's user accounts
  - Create hackathon users
  - Assign hackathon users O365 E5 licenses
- Set up users in Power BI [(PowerShell)](../../blob/main/setup/pbisetup.ps1)
  - Create a workspace for each hackathon user
  - Assign dedicated capacity to workspaces
  - Assign hackathon user as contributor to workspace (1:1)
