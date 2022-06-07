$Credential = Get-Credential
Connect-MsolService -Credential $Credential
Connect-SPOService -Credential $Credential -Url https://m365x00258575-admin.sharepoint.com/

$list = @()
#Counters
$i = 0


#Get licensed users
$users = Get-MsolUser -All | Where-Object { $_.islicensed -eq $true -and $_.DisplayName -like "hacker*"}
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