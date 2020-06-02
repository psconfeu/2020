
#region AutoLearn
# derive from ArgumentTransformationAttribute:
class AutoLearnAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    # define path to store hint lists
    [string]$Path = "$env:temp\hints"

    # define id to manage multiple hint lists:
    [string]$Id = 'default'

    # define prefix character used to delete the hint list
    [char]$ClearKey = '!'

    # define parameterless constructor:
    AutoLearnAttribute() : base()
    {}

    # define constructor with parameter for id:
    AutoLearnAttribute([string]$Id) : base()
    {
        $this.Id = $Id
    }
    
    # Transform() is called whenever there is a variable or parameter assignment, and returns the value
    # that is actually assigned:
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # make sure the folder with hints exists
        $exists = Test-Path -Path $this.Path
        if (!$exists) { $null = New-Item -Path $this.Path -ItemType Directory }

        # create filename for hint list
        $filename = '{0}.hint' -f $this.Id
        $hintPath = Join-Path -Path $this.Path -ChildPath $filename
        
        # use a hashtable to keep hint list
        $hints = @{}

        # read hint list if it exists
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            Get-Content -Path $hintPath -Encoding Default |
              # remove leading and trailing blanks
              ForEach-Object { $_.Trim() } |
              # remove empty lines
              Where-Object { ![string]::IsNullOrEmpty($_) } |
              # add to hashtable
              ForEach-Object {
                # value is not used, set it to $true:
                $hints[$_] = $true
              }
        }

        # does the user input start with the clearing key?
        if ($inputData.StartsWith($this.ClearKey))
        {
            # remove the prefix:
            $inputData = $inputData.SubString(1)

            # clear the hint list:
            $hints.Clear()
        }

        # add new value to hint list
        if(![string]::IsNullOrWhiteSpace($inputData))
        {
            $hints[$inputData] = $true
        }
        # save hints list
        $hints.Keys | Sort-Object | Set-Content -Path $hintPath -Encoding Default 
        
        # return the user input (if there was a clearing key at its start,
        # it is now stripped):
        return $inputData
    }
}

class AutoCompleteAttribute : System.Management.Automation.ArgumentCompleterAttribute
{
    # define path to store hint lists
    [string]$Path = "$env:temp\hints"

    # define id to manage multiple hint lists:
    [string]$Id = 'default'
  
    # define parameterless constructor:
    AutoCompleteAttribute() : base([AutoCompleteAttribute]::_createScriptBlock($this)) 
    {}

    # define constructor with parameter for id:
    AutoCompleteAttribute([string]$Id) : base([AutoCompleteAttribute]::_createScriptBlock($this))
    {
        $this.Id = $Id
    }

    # create a static helper method that creates the scriptblock that the base constructor needs
    # this is necessary to be able to access the argument(s) submitted to the constructor
    # the method needs a reference to the object instance to (later) access its optional parameters:
    hidden static [ScriptBlock] _createScriptBlock([AutoCompleteAttribute] $instance)
    {
    $scriptblock = {
        # receive information about current state:
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
   
        # create filename for hint list
        $filename = '{0}.hint' -f $instance.Id
        $hintPath = Join-Path -Path $instance.Path -ChildPath $filename
        
        # use a hashtable to keep hint list
        $hints = @{}

        # read hint list if it exists
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            Get-Content -Path $hintPath -Encoding Default |
              # remove leading and trailing blanks
              ForEach-Object { $_.Trim() } |
              # remove empty lines
              Where-Object { ![string]::IsNullOrEmpty($_) } |
              # filter completion items based on existing text:
              Where-Object { $_.LogName -like "$wordToComplete*" } | 
              # create argument completion results
              Foreach-Object { 
                  [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
              }
        }
    }.GetNewClosure()
    return $scriptblock
    }
}
#endregion

#region CacheCredential
# attribute [CacheCredential()] transforms strings to creds and caches values:
class CacheCredentialAttribute : System.Management.Automation.ArgumentTransformationAttribute
{
    [string]$Path = "$env:temp\hints"
    [string]$Id = 'default'
    [char]$ClearKey = '!'

    CacheCredentialAttribute() : base()
    {}

    CacheCredentialAttribute([string]$Id) : base()
    {
        $this.Id = $Id
    }
    
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData)
    {
        # make sure the folder with hints exists
        $exists = Test-Path -Path $this.Path
        if (!$exists) { $null = New-Item -Path $this.Path -ItemType Directory }

        # create filename for hint list
        $filename = '{0}.xmlhint' -f $this.Id
        $hintPath = Join-Path -Path $this.Path -ChildPath $filename
        
        # use a hashtable to keep hint list
        $hints = @{}

        # read hint list if it exists
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            # hint list is xml data
            # it is a serialized hashtable and can be 
            # deserialized via Import-CliXml if it exists
            # result is a hashtable:
            [System.Collections.Hashtable]$hints = Import-Clixml -Path $hintPath
        }

        # if the argument is a string...
        if ($inputData -is [string])
        {
            # does username start with "!"?
            [bool]$promptAlways = $inputData.StartsWith($this.ClearKey)

            # if not,...
            if (!$promptAlways)
            {
                # ...check to see if the username has been used before,
                # and re-use its credential (no need to enter password again)
                if ($hints.ContainsKey($inputData))
                {
                    return $hints[$inputData]
                }
            }
            else
            {
                # ...else, remove the "!" at the beginning and prompt
                # again for the password (this way, passwords can be updated)
                $inputData = $inputData.SubString(1)
                # delete the cached credentials
                $hints.Clear()
            }
            # ask for a credential:
            $cred = $engineIntrinsics.Host.UI.PromptForCredential("Enter password", "Please enter user account and password", $inputData, "")
            # add the credential to the hashtable:
            $hints[$cred.UserName] = $cred
            # update the hashtable and write it to file
            # passwords are automatically safely encrypted:
            $hints | Export-Clixml -Path $hintPath
            # return the credential:
            return $cred
        }
        # if a credential was submitted...
        elseif ($inputData -is [PSCredential])
        {
            # save it to the hashtable:
            $hints[$inputData.UserName] = $inputData
            # update the hashtable and write it to file:
            $hints | Export-Clixml -Path $hintPath
            # return the credential:
            return $inputData
        }
        throw [System.InvalidOperationException]::new('Unexpected error.')
    }
}


# attribute [SuggestCredential()] suggests cached credentials
class SuggestCredentialAttribute : System.Management.Automation.ArgumentCompleterAttribute
{
    [string]$Path = "$env:temp\hints"
    [string]$Id = 'default'
  
    SuggestCredentialAttribute() : base([SuggestCredentialAttribute]::_createScriptBlock($this)) 
    {}

    SuggestCredentialAttribute([string]$Id) : base([SuggestCredentialAttribute]::_createScriptBlock($this))
    {
        $this.Id = $Id
    }

    hidden static [ScriptBlock] _createScriptBlock([SuggestCredentialAttribute] $instance)
    {
    $scriptblock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
   
        $filename = '{0}.xmlhint' -f $instance.Id
        $hintPath = Join-Path -Path $instance.Path -ChildPath $filename
        
        $exists = Test-Path -Path $hintPath
        if ($exists) 
        {
            # read serialized hint hashtable if it exists...
            [System.Collections.Hashtable]$hints = Import-Clixml -Path $hintPath

            # hint the sorted list of cached user names...
            $hints.Keys |
              Where-Object { $_ } |
              # ...that still match the current user input:
              Where-Object { $_.LogName -like "$wordToComplete*" } | 
              Sort-Object |
              # return completion results:
              Foreach-Object { 
                  [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
              }
        }
    }.GetNewClosure()
    return $scriptblock
    }
}


# function uses a parameter -Credential that accepts both
# strings (username) and credentials. If the user submits a
# string, a cached credential is returned if available.
# only if there is no cached credential yet, the user gets
# prompted for a password, and the string is transformed
# into a credential.
# when the user prefixes a username with "!", all cached
# credentials are deleted´.
#endregion

# see: https://powershell.one/powershell-internals/attributes/custom-attributes
function Connect-MyServer
{
    param
    (
        [string]
        [Parameter(Mandatory)]
        [AutoLearn('server')][AutoComplete('server')]
        $ComputerName,

        [PSCredential]
        [CacheCredential('account')][SuggestCredential('account')]
        $Credential
    )

    # expose password:
    if ($Credential) {
      $password = $Credential.GetNetworkCredential().Password
      $username = $Credential.UserName
    }

    "hello $Username, connecting you to $ComputerName using password $password."
}