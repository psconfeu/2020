
# issue shows when you actually try and RECEIVE objects:
$received = 1..10 | Foreach-Object {
    if ($_ -eq 5)
    {
        break
    }

    "I am processing...$_"
}

"I have received: $received"