# Microsoft Power BI Cmdlets for Windows PowerShell and PowerShell Core
# https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps

<#
Credentials:
#admin@M365x25073779.onmicrosoft.com
#q53b64K61B
#>

Install-Module -Name MicrosoftPowerBIMgmt
Install-Module -Name MicrosoftPowerBIMgmt.Workspaces

Connect-MsolService
Connect-PowerBIServiceAccount   # or use aliases: Login-PowerBIServiceAccount, Login-PowerBI

Get-PowerBIWorkspace -Scope Organization -All
Get-PowerBICapacity -Scope Organization
<# 
0DDFCC0F-870C-46AF-AA28-783A498BD180 (Premium per User, sign up for premium per user trial and attach a workspace to get the id)
EB214189-CF47-4B98-98B5-16E4AE15EFA0 (Embedded, set up workspace attached to the embedded capacity to get the id) 
#>

# RESET Delete hacker workspaces 
(Get-PowerBIWorkspace -Scope Organization -All | where {$_.Name -like "hacker*workspace" -and $_.state -eq "active"}) | foreach {
        $Id = $_.Id  
        $Url = "groups/$Id"
        Invoke-PowerBIRestMethod -Url $Url -Method Delete 
}

# Choose capacity to be either embedded or Premium per User from above   
$capacityId = "EB214189-CF47-4B98-98B5-16E4AE15EFA0" 

# Create hacker workspaces, assign capacity, and add user as contributor
$userArray = Get-MsolUser -All  | where {$_.DisplayName -like "hacker*" -and $_.isLicensed -eq $true} 
for ($i=0; $i -lt $userArray.Count; $i++)
{ 
    $workspaceName = "$($userArray[$i].DisplayName) workspace"  
    New-PowerBIWorkspace -Name $workspaceName

    $workspace = Get-PowerBIWorkspace -Scope Organization -All | where {$_.Name -eq $workspaceName -and $_.state -eq "active"}    
    Set-PowerBIWorkspace -Scope Organization -Id $workspace.Id -CapacityId $capacityId
    
    Add-PowerBIWorkspaceUser -Scope Organization -Id $workspace.Id -UserEmailAddress $userArray[$i].UserPrincipalName -AccessRight Contributor    
}      
