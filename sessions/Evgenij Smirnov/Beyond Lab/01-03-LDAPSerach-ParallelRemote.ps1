<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 01 - Scale-Up with Active Directory
    Demo 02 - [ADSISearcher] in parallel
#>
#region init
$dcs = @("BLDC01.beyondlab.metabpa.org","BLDC02.beyondlab.metabpa.org","BLDC03.beyondlab.metabpa.org","BLDC04.beyondlab.metabpa.org")
$RootOU = "OU=BL-PROD,DC=beyondlab,DC=metabpa,DC=org"
$results = $null
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region get list of OUs
$s1 = $timer.Elapsed.TotalSeconds
$os=[AdsiSearcher]'(objectcategory=organizationalunit)'
$os.PageSize = 1000
$os.searchRoot = [ADSI]"LDAP://$($dcs[1])/$RootOU"
$os.SearchScope = [System.DirectoryServices.SearchScope]::OneLevel
$null = $os.PropertiesToLoad.Add('distinguishedName')
$ous = $os.FindAll().ForEach({$_.Properties['distinguishedName'][0]})
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "ADSISearcher found $($ous.Count) OUs in $($s2 - $s1) seconds"
#endregion
#region do search in parallel
$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    Param([string]$dnx, [string]$dcx)
    $xsb = {
        Param([string]$dn)
        $res = New-Object System.Collections.ArrayList
        $us = [AdsiSearcher]"ObjectCategory=user"
        $us.PageSize = 1000
        $us.SearchRoot = "LDAP://$dn"
        $us.SearchScope = [System.DirectoryServices.SearchScope]::Subtree
        $null = $us.PropertiesToLoad.Add('sAMACcountName')
        $us.FindAll().ForEach({$null = $res.Add($_.Properties['sAMAccountName'][0])})
        return $res
    }
    return (Invoke-Command -ComputerName $dcx -ScriptBlock $xsb -ArgumentList $dnx)
}
$NumberOfThreads = [math]::Max($ous.Count, [int]$env:NUMBER_OF_PROCESSORS+1) # sweet spot vs. Anhzahl OUs
$pool = [RunspaceFactory]::CreateRunspacePool(1,$NumberOfThreads)
$pool.ApartmentState = "MTA"
$pool.Open()
$runspaces = @()
$results = New-Object System.Collections.ArrayList

$ndc = 0
foreach ($ou in $ous) {
    $dn = "$($DCS[$ndc])/$ou"
    $rs = [PowerShell]::Create()
    $null = $rs.AddScript($scriptblock)
    $null = $rs.AddArgument($dn)
    $null = $rs.AddArgument($DCS[$ndc])
    $rs.RunspacePool = $pool
    $runspaces += [PSCustomObject]@{ Pipe = $rs; Status = $rs.BeginInvoke() }
    $ndc++
    if ($ndc -eq $dcs.Count) { $ndc = 0 }
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Created runspaces in $($s2 - $s1) seconds"

#wait until all runspaces have finished execution
do { Start-Sleep -Milliseconds 200 } until ($runspaces.Status.IsCompleted -notcontains $false) 
$s3 = $timer.Elapsed.TotalSeconds
Write-Host "Runspaces finished in $($s3 - $s2) seconds"

foreach ($rs in $runspaces ) {
    # EndInvoke method retrieves the results of the asynchronous call
    $results += $rs.Pipe.EndInvoke($rs.Status)
    $rs.Pipe.Dispose()
}
$s4 = $timer.Elapsed.TotalSeconds
Write-Host "Retrieved $($results.Count) results from runspaces in $($s4 - $s3) seconds, or $($s4 - $s1) seconds total execution time"

if ($results.Count -gt 0) {
    [System.IO.File]::WriteAllLines("Z:\temp\ldap_para_rem_aduser.txt",$results,[System.Text.Encoding]::UTF8)
}
$s5 = $timer.Elapsed.TotalSeconds
Write-Host "Written results to file in $($s5 - $s4) seconds"

#endregion
#region cleanup
Write-Host " "
#endregion