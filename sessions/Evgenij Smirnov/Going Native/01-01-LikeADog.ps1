<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 01 - Embedding raw .NET code in PowerShell
    Demo 01 - Embedding a class
#>
#region classdefinition
$dotnetclass = @"
// this is all C#
public class Dog
{
   public Dog()
    {
        Name = "Snoopy";
    }

    public Dog (string name)
    {
        Name = name;
    }

    public string Name { get; set; }

    public override string ToString()
    {
        return "Woof! I am " + Name;
    }

    public static string Bark ()
    {
        return "Woof! Woof!";
    }
}
"@
#endregion
#region here we create a PowerShell Type wrapper for our C# class

$DogType = Add-Type -TypeDefinition $dotnetclass -PassThru
<#
    We could just as well use
    Add-Type -TypeDefinition $dotnetclass
#>

#endregion
#region let's look at the type

$DogType | Format-List Name, Module, AssemblyQualifiedName

#endregion
#region we can instantiate the class

$myDog = New-Object Dog
$myDog.Name
$myDog.Name = 'Rex'

#endregion
#region this instance gets a name at birth

$myOtherDog = New-Object Dog ("Lassie")
$myOtherDog.Name
$myOtherDog.ToString()

#endregion
#region another way to construct a Dog

$myThirdDog = [Dog]::new("Caesar")
$myThirdDog.ToString()

#endregion
#region we can even call static methods

[Dog]::Bark()

#endregion
