<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 03 - Passing parameters
    Demo 02 - ByVal vs. ByRef in .NET
#>
#region looking up the method definition
[int] | Get-Member -Static -Name TryParse
# static bool TryParse(string s, [ref] int result)
#endregion
#region ignoring the ref
$i = 0
[int]::TryParse("10",$i)
#endregion
#region respecting the ref
$i = [ref]0
[int]::TryParse("10",$i)
$i.Value
#endregion
#region custom function with ref
$myclass = @"
public class Example0302ref
{
    public Example0302ref()
    {
        Name = "0302";
    }

    public Example0302ref (string name)
    {
        Name = name;
    }

    public string Name { get; set; }

    public static bool LongerThanSix (ref string arg)
    {
        if (arg.Length > 6)
        {
            arg = arg.Substring(0,6);
            return true;
        }
        else
        {
            return false;
        }
    }
}
"@
Add-Type $myclass
$a = [ref]"12345"
[Example0302ref]::LongerThanSix($a)
"a = $($a.Value)"
$b = [ref]"1234567"
[Example0302ref]::LongerThanSix($b)
"b = $($b.Value)"
#endregion
#region custom function with out
$myclass = @"
public class Example0302out
{
    public Example0302out()
    {
        Name = "0302";
    }

    public Example0302out (string name)
    {
        Name = name;
    }

    public string Name { get; set; }

    public static bool LongerThanSixOut (string arg, out string truncatedarg)
    {
        if (arg.Length > 6)
        {
            truncatedarg = arg.Substring(0,6);
            return true;
        }
        else
        {
            truncatedarg = arg;
            return false;
        }
    }
}
"@
Add-Type $myclass
$a = [ref]"12345"
[Example0302out]::LongerThanSixOut("12345",$a)
"a = $($a.Value)"
$b = [ref]"1234567"
[Example0302out]::LongerThanSixOut("1234567",$b)
"b = $($b.Value)"
#endregion