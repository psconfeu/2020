<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Scaling out with IIS logs
    Demo 05 - Searching for IP addresses remotely with earliest possible breakout
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][ValidateRange(1,4)][int]$NIPs = 4,
    [Parameter(Mandatory = $false)][ValidateRange(1,50)][int]$NMachines = 50,
    [Parameter(Mandatory = $false)][ValidateRange(1,10)][int]$BatchSize = 5
)
#region init
$ips = @("141.20.1.3","88.22.37.43","105.44.31.26","160.83.8.29") | Select-Object -First $NIPs
$drv = "C"
$pth = "inetpub\logs\LogFiles"
$computers = New-Object System.Collections.ArrayList
(0..($NMachines - 1)) | foreach {
    $null = $computers.Add("WLIIS$($_.ToString().PadLeft(3,"0"))")
}

Write-Host "`r`nSearching for IP addresses: $($computers.Count) machines, $($ips.Count) IP addresses"
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion

# THIS IS STILL WORK IN PROGRESS


$NumberOfThreads = [math]::Min($computers.Count, [int]$env:NUMBER_OF_PROCESSORS+1) # sweet spot vs. number of computers
$pool = [RunspaceFactory]::CreateRunspacePool(1,$NumberOfThreads)
$pool.ApartmentState = "MTA"
$pool.Open()
$runspaces = @()

foreach ($cname in $computers) {
    $rs = [PowerShell]::Create()
    $null = $rs.AddScript($scriptblock)
    $null = $rs.AddArgument($cname)
    $rs.RunspacePool = $pool
    $runspaces += [PSCustomObject]@{ Pipe = $rs; Status = $rs.BeginInvoke() }
}

do { Start-Sleep -Milliseconds 200 } until ($runspaces.Status.IsCompleted -notcontains $false) 

foreach ($rs in $runspaces ) {
    # EndInvoke method retrieves the results of the asynchronous call
    $result = $rs.Pipe.EndInvoke($rs.Status)
    $rs.Pipe.Dispose()
    $nfiles += $result.Count
    $szfiles += ($result.Sum / 1MB)
}

$pool.Close() 
$pool.Dispose()



#region cleanup
Write-Host " "
#endregion