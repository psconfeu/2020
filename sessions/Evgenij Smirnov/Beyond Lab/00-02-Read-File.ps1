<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 00 - Warming up
    Demo 02 - Reading a long text file into memory
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][string]$InputFile = "Z:\temp\arrlist_iofile.txt"
)
#region init
Write-Host " "
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region getcontent
$s1 = $timer.Elapsed.TotalSeconds
$arr1 = Get-Content -Path $InputFile -Encoding UTF8
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Get-Content: elapsed $($s2 - $s1) seconds, read $($arr1.Count) entries"
#endregion
#region streamreader
$s1 = $timer.Elapsed.TotalSeconds
$arr2 = New-Object System.Collections.ArrayList
$of = New-Object System.IO.StreamReader($InputFile)
while ($of.Peek() -ge 0) {
    $null = $arr2.Add($of.ReadLine())
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "StreamReader.ReadLine: elapsed $($s2 - $s1) seconds, read $($arr2.Count) entries"
#endregion
#region readallines
$s1 = $timer.Elapsed.TotalSeconds
$arr3 = [System.IO.File]::ReadAllLines($InputFile)
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "IO.File.ReadAllLines: elapsed $($s2 - $s1) seconds, read $($arr3.Count) entries"
#endregion
#region cleanup
Write-Host " "
#endregion