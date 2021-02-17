$demo_layout = [ordered]@{
    'Embedding .NET' = @("01-01-LikeADog.ps1","01-02-PetsGalore.ps1","01-03-AddFunction.ps1")
    'Calling .NET' = @("02-01-Add-DLL.ps1","02-02-Load-DLL.ps1")
    'Passing Parameters' = @("03-01-ByRef-PS.ps1","03-02-ByRef-NET.ps1")
    'Handling Errors' = @("04-01-Errors-PS.ps1","04-02-Errors-NET.ps1")
    'Native Code' = @()
}
if ($psise.CurrentVisibleVerticalTool.IsVisible) {
    $psise.CurrentVisibleVerticalTool.IsVisible = $false
}
$current_tab = $psise.CurrentPowerShellTab
$current_tab.DisplayName = "Start-Demo"
foreach ($demo in $demo_layout.GetEnumerator()) {
    $demo_tab = $psise.PowerShellTabs.Add()
    $demo_tab.DisplayName = $demo.Name    
    foreach ($file in $demo.Value) {
        $demo_file = $demo_tab.Files.Add((Join-Path -Path $PSScriptRoot -ChildPath $file))
        $demo_file.Editor.EnsureVisible(1)
        $demo_file.Editor.Focus()
        $demo_file.Editor.ToggleOutliningExpansion()
    }
}
#Start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "http://devws/Home/Index"
$psise.PowerShellTabs.SetSelectedPowerShellTab($current_tab)