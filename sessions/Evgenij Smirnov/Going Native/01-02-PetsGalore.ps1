<#
    Evgenij Smirnov | @cj_berlin | es@it-pro-berlin.de
    Demo code for "Going Native" @ PSConfEU virtual edition
    June 2020, Internet, World
    Scenario 01 - Embedding raw .NET code in PowerShell
    Demo 02 - Embedding multiple classes
#>
#region classdefinition
$dogclass = @"
namespace Pets {
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

        public static string Bark()
        {
            return "Woof! Woof!";
        }
    }
}
"@
$catclass = @"
namespace Pets {
    public class Cat
    {
       public Cat()
        {
            Name = "Seek";
        }

        public Cat (string name)
        {
            Name = name;
        }

        public string Name { get; set; }

        public override string ToString()
        {
            return "Meow! I am " + Name;
        }

        public static string Meow()
        {
            return "Meooooooow!";
        }
    }
}
"@
#endregion
#region adding the classes
Add-Type $dogclass
Add-Type $catclass
#endregion