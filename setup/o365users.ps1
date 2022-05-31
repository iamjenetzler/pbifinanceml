# Connect to Microsoft 365 with PowerShell
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell?view=o365-worldwide#connect-with-the-azure-active-directory-powershell-for-graph-module

Install-Module AzureAD
Import-Module  AzureAD
Connect-AzureAD
Install-Module MSOnline
Connect-MsolService
Install-Module PowerShellGet -Force
Install-Module Microsoft.Graph -Scope AllUsers

Set-ExecutionPolicy RemoteSigned
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

# Remove Office 365 E5 licenses from environment's pre-made user accounts
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/remove-licenses-from-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
$userArray = Get-MsolUser -All  | where {$_.isLicensed -eq $true}   
for ($i=0; $i -lt $userArray.Count; $i++)
{

    $SKUs = @($userArray[$i].Licenses) 
    foreach ($SKU in $SKUs) 
    {     
        
        if ($SKU.AccountSkuId -ieq "M365x25073779:ENTERPRISEPREMIUM") 
        {
            Write "Removing license $($Sku.AccountSkuId) from user $($userArray[$i].UserPrincipalName)"
            Set-MsolUserLicense -UserPrincipalName $userArray[$i].UserPrincipalName -RemoveLicenses $SKU.AccountSkuId
        }
    }
}

# Create Microsoft 365 user accounts for the hackers from csv (UserPrincipalName, FirstName, LastName, DisplayName, UsageLocation, AccountSkuID)
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/create-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
Import-Csv -Path "C:\Users\jeetzler\Documents\Users.csv" |
foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId -ForceChangePassword 0} |
    Export-Csv -Path "C:\Users\jeetzler\Documents\NewAccounts.csv"
 
 
# RESET Delete hacker user accounts
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/delete-and-restore-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
$userArray = Get-MsolUser -All  | where {$_.DisplayName -like "hacker*" -and $_.isLicensed -eq $true} 
for ($i=0; $i -lt $userArray.Count; $i++)
{
    Remove-MsolUser -UserPrincipalName $userArray[$i].UserPrincipalName
}
