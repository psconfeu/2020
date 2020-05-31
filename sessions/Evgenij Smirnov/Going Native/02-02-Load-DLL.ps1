<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 02 - Adding compiled .NET code to PowerShell
    Demo 02 - Loading a DLL
#>
#region where to find DLL
$dllpath = Join-Path $PSScriptRoot -ChildPath "System.Data.SQLite.dll"
#endregion
#region loading it
[Reflection.Assembly]::LoadFile($dllpath)
#endregion
#region using it
$DBConn = New-Object -TypeName System.Data.SQLite.SQLiteConnection
$DBConn.ConnectionString = "Data Source=C:\TEMP\DB.sqlite"
$DBConn.Open()
$DBConn
$DBConn.Close()
#endregion