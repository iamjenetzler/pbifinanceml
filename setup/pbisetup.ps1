# Microsoft Power BI Cmdlets for Windows PowerShell and PowerShell Core
# https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps


Install-Module -Name MicrosoftPowerBIMgmt
Install-Module -Name MicrosoftPowerBIMgmt.Workspaces

Connect-MsolService
Connect-PowerBIServiceAccount   # or use aliases: Login-PowerBIServiceAccount, Login-PowerBI

Get-PowerBIWorkspace -Scope Organization -All

# Choose capacity to be either embedded or Premium per User from above
Get-PowerBICapacity -Scope Organization | where {$_.DisplayName -eq "Premium Per User - Reserved"} | foreach {$CapacityId= $_.Id}

# Create hacker workspaces, assign capacity, and add user as contributor
$userArray = Get-MsolUser -All  | where {$_.DisplayName -like "hacker*" -and $_.isLicensed -eq $true} 
for ($i=0; $i -lt $userArray.Count; $i++)
{ 
    $workspaceName = "$($userArray[$i].DisplayName) workspace"  
    New-PowerBIWorkspace -Name $workspaceName

    $workspace = Get-PowerBIWorkspace -Scope Organization -All | where {$_.Name -eq $workspaceName -and $_.state -eq "active"}    
    Set-PowerBIWorkspace -Id $workspace.Id -CapacityId $capacityId
    
    Add-PowerBIWorkspaceUser -Id $workspace.Id -UserEmailAddress $userArray[$i].UserPrincipalName -AccessRight Contributor    
}      

# RESET Delete hacker workspaces 
(Get-PowerBIWorkspace -Scope Organization -All | where {$_.Name -like "hacker*workspace" -and $_.state -eq "active"}) | foreach {
        $Id = $_.Id  
        $Url = "groups/$Id"
        Invoke-PowerBIRestMethod -Url $Url -Method Delete 
}
