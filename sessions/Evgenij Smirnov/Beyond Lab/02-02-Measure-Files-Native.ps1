<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Scaling out with IIS logs
    Demo 02 - Counting and measuring using .NET classes
#>
#region init
Write-Host " "
$drv = "C"
$pth = "inetpub\logs\LogFiles"
$computers = New-Object System.Collections.ArrayList
(0..49) | foreach {
    $null = $computers.Add("WLIIS$($_.ToString().PadLeft(3,"0"))")
}
$timer = New-Object System.Diagnostics.Stopwatch
#endregion
#region unc-native-sequential
$timer.Start()
$nfiles = 0
$szfiles = 0
$computers.ForEach({
    $path = ('\\{0}\{1}$\{2}' -f $_,$drv,$pth)
    $dir = [System.IO.DirectoryInfo]::new($path)
    $dir.GetFileSystemInfos().Foreach({
        $szfiles += ($_.Length / 1MB)
        $nfiles++
    })
})
$s1 = $timer.Elapsed.TotalSeconds
Write-Host "FileInfo over UNC: $s1 seconds, found $nfiles files with total $($szfiles / 1024) GB size"
#endregion
#region unc-native-parallel
$s2 = $timer.Elapsed.TotalSeconds
$nfiles = 0
$szfiles = 0
$scriptblock = {
    Param([string]$cname)
    $drv = "C"
    $pth = "inetpub\logs\LogFiles"
    $path = ('\\{0}\{1}$\{2}' -f $cname,$drv,$pth)
    $nfiles = 0
    $szfiles = 0
    $dir = [System.IO.DirectoryInfo]::new($path)
    $dir.GetFileSystemInfos().Foreach({
        $szfiles += ($_.Length / 1MB)
        $nfiles++
    })
    return [PSCustomObject]@{'Count'=$nfiles; 'SzSum' = $szfiles}
}
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
    $nfiles += $result[0].Count
    $szfiles += $result[0].SzSum
}

$pool.Close() 
$pool.Dispose()
$s3 = $timer.Elapsed.TotalSeconds
Write-Host "FileInfo over UNC in parallel: $($s3 - $s2) seconds, found $nfiles files with total $($szfiles / 1024) GB size"
#endregion
#region local-native-remoting
$s1 = $timer.Elapsed.TotalSeconds
$nfiles = 0
$szfiles = 0
(Invoke-Command -ComputerName $computers -ScriptBlock { $path = ('{0}:\{1}' -f $using:drv,$using:pth); $nfiles = 0; $szfiles = 0; $dir = [System.IO.DirectoryInfo]::new($path); $dir.GetFileSystemInfos().Foreach({ $szfiles += ($_.Length / 1MB); $nfiles++ ; }); return [PSCustomObject]@{'Count'=$nfiles; 'SzSum' = $szfiles} }).ForEach({$nfiles += $_.Count; $szfiles += $_.SzSum})

$s2 = $timer.Elapsed.TotalSeconds
Write-Host "FileInfo invoked remotely: $($s2 - $s1) seconds, found $nfiles files with total $($szfiles / 1024) GB size"
#endregion
#region cleanup
Write-Host " "
#endregion