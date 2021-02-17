<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 01 - Embedding raw .NET code in PowerShell
    Demo 03 - Adding just a function
#>
#region classdefinition
$barkmethod = @"
public static string Bark()
{
    return "Woof! I am a standlone method!";
}
"@
#endregion
#region add and call the function
Add-Type -MemberDefinition $barkmethod -Name "VirtualDog" -Namespace "VirtualPets"
[VirtualPets.VirtualDog]::Bark()
#endregion