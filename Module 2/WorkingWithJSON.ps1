
$ComputerName = $env:ComputerName
$ServiceStatus = (Get-Service -Name "Windows Update").Status
$MyWhateverData = "Some data"

$reportObject = [PSCustomObject]@{
    ComputerName   = $ComputerName
    ServiceStatus  = $ServiceStatus
    MyWhateverData = $MyWhateverData   
}

$reportObject | Format-List 
$reportFile = "C:\Temp\MyJSONFile.json"

ConvertTo-Json -InputObject $reportObject | Out-File -FilePath $reportFile 