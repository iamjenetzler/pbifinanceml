# pbifinanceml

## Hackathon Setup

### Prerequisites

- Create a [CDX Environment](https://cdx.transform.microsoft.com)
  - Create an Azure subscription
  - Sign into Azure portal with tenant admin account
  - Use a voucher to create a new subscription
  - Create a [Power BI Embedded](https://docs.microsoft.com/en-us/power-bi/developer/embedded/embedded-capacity?tabs=gen2#sku-memory-and-computing-power") resource in the subscription
- Set up Power BI dedicated capacity
  - Premium per User: sign up for free trial in the Power BI web application
  - Embedded: use the Power BI embedded resource you created in the Azure subscription

### Hackathon User Setup

- Set up users in O365 [(PowerShell)](../../blob/main/o365users.ps1)
  - Revoke O365 licenses from environment's user accounts
  - Create hackathon users
  - Assign hackathon users O365 E5 licenses
- Set up users in Power BI [(PowerShell)](../../blob/main/pbisetup.ps1)
  - Create a workspace for each hackathon user
  - Assign dedicated capacity to workspaces
  - Assign hackathon user as contributor to workspace (1:1)
