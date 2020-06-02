#region Transformation Attribute
# create a transform attribute that transforms plain text to secure string
class SecureStringTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # if a securestring was submitted...
        if ($inputData -is [SecureString])
        {
            # return as-is:
            return $inputData
        }
        # if the argument is a string...
        elseif ($inputData -is [string])
        {
            # convert to secure string:
            return $inputData | ConvertTo-SecureString -AsPlainText -Force
        }
        
        # anything else throws an exception:
        throw [System.InvalidOperationException]::new('Unexpected error.')
    }
}
return
#endregion

# see: https://powershell.one/powershell-internals/attributes/transformation#handling-securestrings

# this fails:
[SecureString]$secret = "Test"
# this works:
[SecureString][SecureStringTransform()]$secret = "Hello"

# accepts secure strings...
$secureText = Read-Host -AsSecureString -Prompt Password
$secureText

function Get-Secret
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [SecureString]
        [SecureStringTransform()]
        $Secret
    )

    # use it, convert it, etc:
    [PSCredential]::new('dummy', $Secret).GetNetworkCredential().Password
}