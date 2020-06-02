#region ValidationAttribute
class ValidatePathExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute
{
    # this class must override the method "Validate()"
    # this method MUST USE the signature below. DO NOT change data types
    # $path represents the value assigned by the user:
    [void]Validate([object]$path, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
        # perform whatever checks you require.
        
        # check whether the path is empty:
        if([string]::IsNullOrWhiteSpace($path))
        {
            # whenever something is wrong, throw an exception:
            Throw [System.ArgumentNullException]::new()
        }
        
        # check whether the path exists:
        if(-not (Test-Path -Path $path))
        {
            # whenever something is wrong, throw an exception:
            Throw [System.IO.FileNotFoundException]::new()
        }        
        
        # if at this point no exception has been thrown, the value is ok
        # and can be assigned.
    }
}
return
#endregion

# see: https://powershell.one/powershell-internals/attributes/validation#creating-custom-validation-attributes

# works:
[ValidatePathExists()][string]$Path = "c:\windows"
$Path = (Get-Process -Id $pid).Path

# fails (does not exist):
$Path = 'e:\doesnotexist.txt'
