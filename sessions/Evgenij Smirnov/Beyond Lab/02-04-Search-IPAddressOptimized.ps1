<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Scaling out with IIS logs
    Demo 04 - Searching for IP addresses remotely, an attempt at optimization
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][ValidateRange(1,4)][int]$NIPs = 4,
    [Parameter(Mandatory = $false)][ValidateRange(1,50)][int]$NMachines = 50
)
#region init
$ips = @("141.20.1.3","88.22.37.43","105.44.31.26","160.83.8.29") | Select-Object -First $NIPs
$drv = "C"
$pth = "inetpub\logs\LogFiles"
$computers = @("WLIIS022")

<#
$computers = New-Object System.Collections.ArrayList
(0..($NMachines - 1)) | foreach {
    $null = $computers.Add("WLIIS$($_.ToString().PadLeft(3,"0"))")
}
#>
Write-Host "`r`nSearching for IP addresses: $($computers.Count) machines, $($ips.Count) IP addresses"
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region select-string
Write-Host "Select-String: cannot be optimized"
#endregion

#region regex
Write-Host "Match every line: cannot be optimized"
#endregion
#region regex-firstfile
$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    $path = ('{0}:\{1}' -f $using:drv,$using:pth)
    $files = New-Object System.Collections.ArrayList
    $res = New-Object System.Collections.Generic.HashSet[string]
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    :outer foreach ($file in $files) {
        $lines = [System.IO.File]::ReadAllLines($file)
        foreach($ip in $using:ips) {
            $pattern = "\s$($ip -replace "\.","\.")\s"
            if($lines.Where({[regex]::Match($_,$pattern).Success}).Count -gt 0) { $null = $res.Add($ip) }
            if ($res.Count -eq $using:ips.Count) { break outer }
        }
    }
    return $res
}
$results = Invoke-Command -ComputerName $computers -ScriptBlock $scriptblock
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Match until first file: elapsed $($s2 - $s1) seconds, IPs found: $(($results | sort -Unique) -join ", ")"
#endregion
#region regex-firstmatch
$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    $path = ('{0}:\{1}' -f $using:drv,$using:pth)
    $files = New-Object System.Collections.ArrayList
    $res = New-Object System.Collections.Generic.HashSet[string]
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    :outer foreach ($file in $files) {
        $lines = [System.IO.File]::ReadAllLines($file)
        foreach($ip in $using:ips) {
            $pattern = "\s$($ip -replace "\.","\.")\s"
            $lines.ForEach({if ([regex]::Match($_,$pattern).Success) { $null = $res.Add($ip); if ($res.Count -eq $using:ips.Count) { break outer } } })
        }
    }
    return $res
}
$results = Invoke-Command -ComputerName $computers -ScriptBlock $scriptblock
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Match until first line: elapsed $($s2 - $s1) seconds, IPs found: $(($results | sort -Unique) -join ", ")"
#endregion