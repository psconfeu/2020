<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 03 - Passing parameters
    Demo 01 - ByVal vs. ByRef in PowerShell
#>
#region function definitions
function Get-Square {
    Param(
        [Parameter()][int]$NumberToSquare
    )
    $NumberToSquare * $NumberToSquare
}
function Get-SquareAndAddOne {
    Param(
        [Parameter()][int]$NumberToSquare
    )
    $NumberToSquare * $NumberToSquare
    $NumberToSquare++
}
function Get-SquareAndAddOneRef {
    Param(
        [Parameter()][ref]$NumberToSquare
    )
    $NumberToSquare.Value * $NumberToSquare.Value
    $NumberToSquare.Value++
}
#endregion
#region function invocations
$x = 5
Get-Square -NumberToSquare $x
$x
Get-SquareAndAddOne -NumberToSquare $x
$x
Get-SquareAndAddOneRef -NumberToSquare ([ref]$x)
$x
Get-SquareAndAddOneRef -NumberToSquare ([ref]$x)
$x
Get-SquareAndAddOneRef -NumberToSquare ([ref]$x)
$x
#endregion