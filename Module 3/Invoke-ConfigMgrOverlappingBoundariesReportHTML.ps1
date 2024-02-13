# Original from Trevor Jones (@SMSagentTrevor on Twitter)

# MEMCM database params
$script:dataSource = 'CM01' # MEMCM SQL server name, include instance if needed
$script:database = 'CM_PS1' # MEMCM database name

# Html CSS style 
$Style = @"
<style>
table { 
    border-collapse: collapse;
    font-family: sans-serif
    font-size: 10px
}
td, th { 
    border: 1px solid #ddd;
    padding: 6px;
}
th {
    padding-top: 8px;
    padding-bottom: 8px;
    text-align: left;
    background-color: #3700B3;
    color: #03DAC6
}
</style>
"@

# Function to get data from SQL server
function Get-SQLData {
    param($Query)
    $connectionString = "Server=$dataSource;Database=$database;Integrated Security=SSPI;"
    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    
    $command = $connection.CreateCommand()
    $command.CommandText = $Query
    $reader = $command.ExecuteReader()
    $table = New-Object -TypeName 'System.Data.DataTable'
    $table.Load($reader)
    
    # Close the connection
    $connection.Close()
    
    return $Table
}

# SQL query
$Query = "
Select * from dbo.BoundaryEx
Where BoundaryType = 3 
and (NumericValueLow is not null
or NumericValueHigh is not null)
"

# Get SQL data
$Results = Get-SQLData -Query $Query 

# Custom class
class OverLappedBoundary
{
    [string]$BoundaryName
    [string]$BoundaryValue
    [string]$OverLappingBoundary
    [string]$OverLappingBoundaryValue
}

# Find the overlapping boundaries
$OverLappingBoundaries = @()
foreach ($Result in $Results)
{
    foreach($Boundary in $Results)
    {
        If ($Result.BoundaryID -ne $Boundary.BoundaryID -and (($Result.NumericValueLow -gt $Boundary.NumericValueLow -and $Result.NumericValueLow -lt $Boundary.NumericValueHigh) -or ($Result.NumericValueHigh -lt $Boundary.NumericValueHigh -and $Result.NumericValueHigh -gt $Boundary.NumericValueLow)))
        {
            $OverLappedBoundary = [OverLappedBoundary]::new()
            $OverLappedBoundary.BoundaryName = $Result.Name 
            $OverLappedBoundary.OverLappingBoundary = $Boundary.Name
            $OverLappedBoundary.BoundaryValue = $Result.Value 
            $OverLappedBoundary.OverLappingBoundaryValue = $Boundary.Value
            $OverLappingBoundaries += $OverLappedBoundary
        }
    }
}

If ($OverLappingBoundaries.Count -ge 1){
    # Prepare the HTML
    $Precontent = "<h3>IP range boundaries on the left are included in the boundaries on the right.</h3>"
    $HTML = $OverLappingBoundaries | ConvertTo-Html -Head $Style -PreContent $Precontent | Out-String


}

# Save the file
$HTML | Out-File -FilePath "E:\Temp\BoundaryOverlapReport.html"

