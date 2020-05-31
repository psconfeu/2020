<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Scaling out with IIS logs
    Demo 06 - Gauging Select-String for local execution
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][ValidateRange(1,4)][int]$NIPs = 3
)
#region init
$ips = @("141.20.1.3","88.22.37.43","105.44.31.26","160.83.8.29") | Select-Object -First $NIPs
$drv = "C"
$pth = "inetpub\logs\LogFiles"
$computers = New-Object System.Collections.ArrayList
(0..($NMachines - 1)) | foreach {
    $null = $computers.Add("WLIIS$($_.ToString().PadLeft(3,"0"))")
}

Write-Host "`r`nSearching for IP addresses locally: $($ips.Count) IP addresses"
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region enumerate files
$path = ('{0}:\{1}' -f $drv,$pth)
$s1 = $timer.Elapsed.TotalSeconds
$files = New-Object System.Collections.ArrayList
([System.IO.Directory]::EnumerateFiles($path)).Foreach({$null = $files.Add($_)})
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Enumerating: $($s2 - $s1) seconds, found $($files.Count) files"
#endregion
#region select over all files
$s1 = $timer.Elapsed.TotalSeconds
$res = New-Object System.Collections.ArrayList
foreach($ip in $ips) {
    if (Select-String -Path $files -Pattern "\s$($ip -replace "\.","\.")\s" -Quiet) { $null = $res.Add($ip) }
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Select-String for each pattern over all files: $($s2 - $s1) seconds, found: $($res -join ", ")"
#endregion
#region looping through ips, then files
$s1 = $timer.Elapsed.TotalSeconds
$res = New-Object System.Collections.ArrayList
:outer foreach($ip in $ips) {
    :inner foreach ($file in $files) {
        if (Select-String -Path $file -Pattern "\s$($ip -replace "\.","\.")\s" -Quiet) { $null = $res.Add($ip); break inner }
    }
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Select-String for each pattern, files are inner: $($s2 - $s1) seconds, found: $($res -join ", ")"
#endregion
#region looping through files, then ips
$s1 = $timer.Elapsed.TotalSeconds
$res = New-Object System.Collections.ArrayList
:outer foreach ($file in $files) {
    :inner foreach($ip in $ips) {
        if (Select-String -Path $file -Pattern "\s$($ip -replace "\.","\.")\s" -Quiet) { $null = $res.Add($ip) }
    }
    if ($res.Count -eq $ips.Count) { break outer }
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Select-String for each pattern, files are outer: $($s2 - $s1) seconds, found: $($res -join ", ")"
#endregion
#region matching multiple patterns
$s1 = $timer.Elapsed.TotalSeconds
$res = New-Object System.Collections.ArrayList
$patterns = foreach($ip in $ips) { "\s$($ip -replace "\.","\.")\s" }
$selres = Select-String -Path $files -Pattern $patterns -List
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Select-String for all patterns: $($s2 - $s1) seconds, found: $(($selres.Pattern | sort -unique) -join ", ")"
#endregion
#region cleanup
Write-Host " "
#endregion