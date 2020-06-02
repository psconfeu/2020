#region pipeline break
function Start-Break
{
    $pipe = { Select-Object -First 1 }.GetSteppablePipeline()
    $pipe.Begin($true)
    $pipe.Process(1)
    $pipe.End()
}
#endregion



$received = 1..10 | Foreach-Object {
    if ($_ -eq 5)
    {
        Start-Break
    }

    "I am processing...$_"
}

"I have received: $received"