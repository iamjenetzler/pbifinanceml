Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
Import-Module Microsoft.Online.SharePoint.PowerShell

$Credential = Get-Credential

Connect-MsolService -Credential $Credential
Connect-SPOService -Url https://MngEnvMCAP996381-admin.sharepoint.com -Credential $Credential 

$list = @()
#Counters
$i = 0


#Get licensed users
$users = Get-MgUser -All  | where { $_.DisplayName -like "hacker*"}   

#total licensed users
$count = $users.count

foreach ($u in $users) {
    $i++
    Write-Host "$i/$count"

    $upn = $u.userprincipalname
    $list += $upn

    if ($i -eq 199) {
        #We reached the limit
        Request-SPOPersonalSite -UserEmails $list -NoWait
        Start-Sleep -Milliseconds 655
        $list = @()
        $i = 0
    }
}

if ($i -gt 0) {
    Request-SPOPersonalSite -UserEmails $list -NoWait
}

#Verify
Get-SPOSite -IncludePersonalSite $true -Limit all -Filter "Url -like '-my.sharepoint.com/personal/'" | Select -ExpandProperty Url  
 