# Connect to Microsoft 365 with PowerShell
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell?view=o365-worldwide#connect-with-the-azure-active-directory-powershell-for-graph-module

Install-Module AzureAD
Import-Module  AzureAD
Install-Module MSOnline
Install-Module PowerShellGet -Force
Install-Module Microsoft.Graph -Scope AllUsers

Connect-MsolService
Connect-AzureAD

Set-ExecutionPolicy RemoteSigned
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

# get the company prefix for the license packages
$licenseList=Get-MsolAccountSku
if(($licenseList.GetType().Name) -eq "AccountSkuDetails") 
{
    $licensePrefix =$licenseList.AccountSkuId.Split(":")[0]
}

else
{
    $licensePrefix =$licenseList[0].AccountSkuId.Split(":")[0]
} 
$tenantName = $licensePrefix
$licensePackage = $licensePrefix + ":ENTERPRISEPREMIUM"


# Remove Office 365 E5 licenses from environment's pre-made user accounts
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/remove-licenses-from-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
$userArray = Get-MsolUser -All  | where {$_.isLicensed -eq $true}   
for ($i=0; $i -lt $userArray.Count; $i++)
{

    $SKUs = @($userArray[$i].Licenses) 
    foreach ($SKU in $SKUs) 
    {             
        if ($SKU.AccountSkuId -ieq ($licensePrefix + ":ENTERPRISEPREMIUM")) 
        {
            Write "Removing license $($Sku.AccountSkuId) from user $($userArray[$i].UserPrincipalName)"
            Set-MsolUserLicense -UserPrincipalName $userArray[$i].UserPrincipalName -RemoveLicenses $SKU.AccountSkuId
        }
    }
}

# Create Microsoft 365 user accounts for the hackers from csv (UserPrincipalName, FirstName, LastName, DisplayName, UsageLocation, AccountSkuID)
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/create-user-accounts-with-microsoft-365-powershell?view=o365-worldwide

# delete output file with the account info if it exists
$UserFileName = "C:\Users\jeetzler\Documents\NewAccounts.csv"
if (Test-Path $UserFileName) 
{
  Remove-Item $UserFileName
}

# create hacker accounts with number suffix i 
for ($i=16; $i -lt 31; $i++) 
{    
    New-MsolUser -DisplayName "hacker$($i)" -UserPrincipalName "hacker$($i)@$($tenantName).onmicrosoft.com" -UsageLocation "US" -LicenseAssignment $licensePackage -ForceChangePassword 0 |
    Export-Csv -Path "C:\Users\jeetzler\Documents\NewAccounts.csv" -Append
} 
 
# RESET Delete hacker user accounts
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/delete-and-restore-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
$userArray = Get-MsolUser -All  | where {$_.DisplayName -like "hacker*" -and $_.isLicensed -eq $true} 
for ($i=0; $i -lt $userArray.Count; $i++)
{
    Remove-MsolUser -UserPrincipalName $userArray[$i].UserPrincipalName -force 
}
