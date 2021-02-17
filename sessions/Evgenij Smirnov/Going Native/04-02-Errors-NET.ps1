$myclass = @"
public class ErrorProne
{
    public ErrorProne()
    {
        
    }

    public static float NewError()
    {
        int a = 0;
        int b = 7;
        float c = b / a;
        return c;
    }
}
"@
#endregion

Add-Type $myclass
Write-Host "Calling NewError..."
[ErrorProne]::NewError()
Write-Host "Trying NewError..."
try {
    [ErrorProne]::NewError()
} catch {
    Write-Warning $_.Exception.Message
}
$ErrorActionPreference = "Stop"
[ErrorProne]::NewError()
Write-Host "If you can see this, the error is still non-terminating"