<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 04 - Handling errors in PowerShell
    Demo 01 - Errors in PowerShell
#>
function New-Error {
    $a = 0
    $b = 7
    return ($b / $a)
}
function New-NTError {
    $path = "X:\somenonexistingfolder"
    return (Get-ChildItem $path)
}
try {
    New-Error
} catch {
    Write-Warning $_.Exception.Message
}
try {
    New-NTError
} catch {
    Write-Warning $_.Exception.Message
}