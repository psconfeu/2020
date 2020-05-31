<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Scaling out with IIS logs
    Demo 03 - Searching for IP addresses remotely
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
$computers = New-Object System.Collections.ArrayList
(0..($NMachines - 1)) | foreach {
    $null = $computers.Add("WLIIS$($_.ToString().PadLeft(3,"0"))")
}

Write-Host "`r`nSearching for IP addresses: $($computers.Count) machines, $($ips.Count) IP addresses"
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region select-string

$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    $path = ('{0}:\{1}' -f $using:drv,$using:pth)
    $files = New-Object System.Collections.ArrayList
    $res = New-Object System.Collections.ArrayList
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    foreach($ip in $using:ips) {
        if (Select-String -Path $files -Pattern "\s$($ip -replace "\.","\.")\s" -Quiet) { $null = $res.Add($ip) }
    }
    return $res
}
$results = Invoke-Command -ComputerName $computers -ScriptBlock $scriptblock
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Select-String: elapsed $($s2 - $s1) seconds, IPs found: $(($results | sort -Unique) -join ", ")"
#endregion

#region regex
$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    $path = ('{0}:\{1}' -f $using:drv,$using:pth)
    $files = New-Object System.Collections.ArrayList
    $res = New-Object System.Collections.ArrayList
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    foreach($ip in $using:ips) {
        $pattern = "\s$($ip -replace "\.","\.")\s"
        $found = $false
        foreach ($file in $files) {
            if([System.IO.File]::ReadAllLines($file).Where({[regex]::Match($_,$pattern).Success}).Count -gt 0) { $found = $true }
        }
        if ($found) { $null = $res.Add($ip) }
    }
    return $res
}
#$results = Invoke-Command -ComputerName $computers -ScriptBlock $scriptblock
$s2 = $timer.Elapsed.TotalSeconds
#Write-Host "Match every line: elapsed $($s2 - $s1) seconds, IPs found: $(($results | sort -Unique) -join ", ")"
#endregion
#region regex-firstfile
$s1 = $timer.Elapsed.TotalSeconds
$scriptblock = {
    $path = ('{0}:\{1}' -f $using:drv,$using:pth)
    $files = New-Object System.Collections.ArrayList
    $res = New-Object System.Collections.ArrayList
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    foreach($ip in $using:ips) {
        $pattern = "\s$($ip -replace "\.","\.")\s"
        $found = $false
        :inner foreach ($file in $files) {
            if([System.IO.File]::ReadAllLines($file).Where({[regex]::Match($_,$pattern).Success}).Count -gt 0) { $found = $true; break inner }
        }
        if ($found) { $null = $res.Add($ip) }
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
    $res = New-Object System.Collections.ArrayList
    ([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
    foreach($ip in $using:ips) {
        $pattern = "\s$($ip -replace "\.","\.")\s"
        $found = $false
        :outer foreach ($file in $files) {
            [System.IO.File]::ReadAllLines($file).ForEach({if([regex]::Match($_,$pattern).Success) { $found = $true; break outer } })
        }
        if ($found) { $null = $res.Add($ip) }
    }
    return $res
}
$results = Invoke-Command -ComputerName $computers -ScriptBlock $scriptblock
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Match until first line: elapsed $($s2 - $s1) seconds, IPs found: $(($results | sort -Unique) -join ", ")"
#endregion
#region cleanup
Write-Host " "
#endregion