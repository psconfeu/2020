<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 01 - Scale-Up with Active Directory
    Demo 01 - Gauging Get-ADUser and [ADSISearcher]
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][ValidateRange(0,3)][int]$DC = 2
)
#region init
$dcs = @("BLDC01.beyondlab.metabpa.org","BLDC02.beyondlab.metabpa.org","BLDC03.beyondlab.metabpa.org","BLDC04.beyondlab.metabpa.org")
$RootOU = "OU=BL-PROD,DC=beyondlab,DC=metabpa,DC=org"
Import-Module ActiveDirectory
$results = $null
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region get-aduser
$s1 = $timer.Elapsed.TotalSeconds
try {
    $results = Get-ADUser -Filter * -SearchBase $RootOU -SearchScope Subtree -Server $dcs[$DC] -EA Stop | Select-Object -ExpandProperty sAMACcountName
} catch {
    Write-Warning $_.Exception.Message
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Get-ADUser finished in $($s2 - $s1) seconds, retrieved $($results.Count) results from DC# $DC"
$s3 = $timer.Elapsed.TotalSeconds
if ($results.Count -gt 0) {
    [System.IO.File]::WriteAllLines("C:\temp\get_aduser.txt",$results,[System.Text.Encoding]::UTF8)
}
$s4 = $timer.Elapsed.TotalSeconds
Write-Host "Written results to file in $($s4 - $s3) seconds"
#endregion
#region adsisearcher
# querying another dc
$DC++ 
if ($DC -eq 4) { $DC = 0 }
$s1 = $timer.Elapsed.TotalSeconds
$ds=[AdsiSearcher]"ObjectCategory=user"
$ds.PageSize = 1000
$ds.SizeLimit = 1000
$ds.searchRoot = [ADSI]"LDAP://$($dcs[$DC])/$RootOU"
$ds.SearchScope = [System.DirectoryServices.SearchScope]::Subtree
$null = $ds.PropertiesToLoad.Add('sAMACcountName')
try {
    $results = $ds.FindAll().ForEach({$_.Properties['sAMAccountName'][0]})
} catch {
    Write-Warning $_.Exception.Message
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "ADSISearcher finished in $($s2 - $s1) seconds, retrieved $($results.Count) results from DC# $DC"
$s3 = $timer.Elapsed.TotalSeconds
if ($results.Count -gt 0) {
    [System.IO.File]::WriteAllLines("Z:\temp\adsisearcher.txt",$results,[System.Text.Encoding]::UTF8)
}
$s4 = $timer.Elapsed.TotalSeconds
Write-Host "Written results to file in $($s4 - $s3) seconds"
#endregion
#region cleanup
Write-Host " "
#endregion