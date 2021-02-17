<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Beyond Lab" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 00 - Warming up
    Demo 01 - Generating lines of text and writing them to file
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)][int]$NumberOfLines = 1000000,
    [Parameter(Mandatory = $false)][string]$OutPath = "Z:\temp"
)
#region init
Write-Host " "
$arr = New-Object System.Collections.ArrayList($string) # don't even try using arrays here ;-)
$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()
#endregion
#region generation
$s1 = $timer.Elapsed.TotalSeconds
for($i = 0;$i -lt $NumberOfLines; $i++) {
    $null = $arr.Add($i.ToString().PadLeft(16,"0"))
}
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Generation of $NumberOfLines entries: elapsed $($s2 - $s1) seconds"
#endregion
#region outfile
$s1 = $timer.Elapsed.TotalSeconds
$arr | Out-File (Join-Path -Path $OutPath -ChildPath "arrlist_outfile.txt") -Encoding utf8
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Out-File: elapsed $($s2 - $s1) seconds"
#endregion
#region setcontent
$s1 = $timer.Elapsed.TotalSeconds
$arr | Set-Content (Join-Path -Path $OutPath -ChildPath "arrlist_setcontent.txt")
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "Set-Content: elapsed $($s2 - $s1) seconds"
#endregion
#region streamwriter
$s1 = $timer.Elapsed.TotalSeconds
$of = New-Object System.IO.StreamWriter((Join-Path -Path $OutPath -ChildPath "arrlist_streamwriter.txt"),[System.Text.Encoding]::UTF8)
$arr.ForEach({$of.WriteLine($_)})
$of.Close()
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "StreamWriter.WriteLine: elapsed $($s2 - $s1) seconds"
#endregion
#region writealllines
$s1 = $timer.Elapsed.TotalSeconds
[System.IO.File]::WriteAllLines((Join-Path -Path $OutPath -ChildPath "arrlist_iofile.txt"),$arr,[System.Text.Encoding]::UTF8)
$s2 = $timer.Elapsed.TotalSeconds
Write-Host "IO.File.WriteAllLines: elapsed $($s2 - $s1) seconds"
#endregion
#region cleanup
Write-Host " "
#endregion