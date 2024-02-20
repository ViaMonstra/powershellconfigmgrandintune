$Clients = "CH1-PC0001", "CH1-PC0002"

[System.Collections.ArrayList]$Info = @()
foreach($Client in $Clients){

    $ComputerName = $Client
    $OSName = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Client).Caption

        $obj = [PSCustomObject]@{

        # Add values to arraylist
        "ComputerName" = $ComputerName 
        "OSName" = $OSName 

        }

        # Add all the values
        $Info.Add($obj)|Out-Null

}

$Info | Export-Csv -Path "C:\Temp\I