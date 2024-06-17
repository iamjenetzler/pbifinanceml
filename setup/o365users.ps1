# Connect to Microsoft 365 with PowerShell
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell?view=o365-worldwide#connect-with-the-azure-active-directory-powershell-for-graph-module

Install-Module AzureAD
Import-Module  AzureAD
Install-Module MSOnline
Install-Module PowerShellGet -Force


# Open PowerShell as an Administrator

# Uninstall the existing Microsoft.Graph module
Uninstall-Module -Name Microsoft.Graph -AllVersions -Force

# Install the latest Microsoft.Graph module
Install-Module -Name Microsoft.Graph -AllowClobber -Force

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All", "Directory.AccessAsUser.All"


Connect-AzureAD

Set-ExecutionPolicy RemoteSigned
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All


# get the company prefix for the license packages
$licenseList=Get-MsolAccountSku
$licensePrefix =$licenseList[0].AccountSkuId.Split(":")[0]

$tenantName = $licensePrefix
$licensePackage = $licensePrefix + ":SPE_E5"

# Retrieve the SKU ID for the E5 license
$accountSkuId = Get-MgSubscribedSku | Select-Object SkuId, SkuPartNumber | where {$_.SkuPartNumber -like "SPE_E5" }   

# Remove Office 365 E5 licenses from environment's pre-made user accounts
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/remove-licenses-from-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
#Get-MgUser -All | Format-List  ID, DisplayName, Mail, UserPrincipalName, AssignedLicenses, AssignedPlans


$userArray = Get-MgUser -All  | where {$_.UserPrincipalName -notlike "admin*" }   
for ($i=0; $i -lt $userArray.Count; $i++)
{   

    $SKUs = Get-MgUserLicenseDetail -UserId $userArray[$i].Id
    foreach ($SKU in $SKUs) 
    {             
        if ($SKU.SkuPartNumber -ieq ("SPE_E5")) 
        {
            Write "Sku: " $Sku.SkuId
            Write "User: " $userArray[$i].Id
            Write "Removing license $($Sku.SkuId) from user $($userArray[$i].Id)"
            Set-MgUserLicense -UserId $userArray[$i].Id -AddLicenses @() -RemoveLicenses @($accountSkuId.SkuId)
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

Get-MgSubscribedSku | Select-Object SkuId, SkuPartNumber


# create hacker accounts with number suffix i 
for ($i = 1; $i -lt 5; $i++) 
{
    try {
        # Create a new user
        $newUser = New-MgUser -AccountEnabled:$true -DisplayName "hacker$($i)" `
                              -UserPrincipalName "hacker$($i)@$($tenantName).onmicrosoft.com" `
                              -MailNickname "hacker$($i)" `
                              -PasswordProfile @{ForceChangePasswordNextSignIn = $false; Password = "TempP@ssword123"} `
                              -UsageLocation "US"
        
        if ($null -ne $newUser) {
            $userId = $newUser.Id            

            # Assign the license to the new user
            Set-MgUserLicense -UserId $userId -AddLicenses  @{SkuId = $accountSkuId.SkuId} -RemoveLicenses @()         
            
            # Export user information to CSV
            $newUser | Select-Object Id, DisplayName, UserPrincipalName | Export-Csv -Path $UserFileName -Append -NoTypeInformation
        }
        else {
            Write-Host "Failed to create user hacker$($i)"
        }
    }
    catch {
        Write-Host "An error occurred while creating user hacker$($i): $_"
    }
}
 
# RESET Delete hacker user accounts

$userArray = Get-MgUser -All  | where {$_.UserPrincipalName -like "hacker*" }   
for ($i=0; $i -lt $userArray.Count; $i++)
{
    Write-Host "Removing user " $userArray[$i].Id
    Remove-MgUser -UserId $userArray[$i].Id  
}

# Connect to Microsoft Graph if not already connected
if (-not (Get-Module -Name Microsoft.Graph -ErrorAction SilentlyContinue)) {
    Connect-MgGraph -Scopes "User.Read.All"
}

 