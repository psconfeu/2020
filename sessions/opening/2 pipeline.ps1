


1..10 | Foreach-Object {
    if ($_ -eq 5)
    {
        break
    }

    "I am processing...$_"
}
"Hello"