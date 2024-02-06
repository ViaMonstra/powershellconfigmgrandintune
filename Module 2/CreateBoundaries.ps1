$SiteServer = "CM01"
$SiteCode = "PS1"

# Connect to ConfigMgr
if($null -eq (Get-Module ConfigurationManager)) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
}
if($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $SiteServer 
}
Set-Location "$($SiteCode):\" 

# Define a variable containing the path for the data to import
$subnetFile = "C:\Temp\subnets.csv"

# Create a list of the subnets in the file
$data = import-csv -Path $subnetFile -Delimiter ','

# Loop thru the list of subnets
Foreach ($item in $data) {

    # Show a bit of progress to the user
    Write-Host "Processing $($item.Name)"

    # Let's see if a boundary already exists for the current subnet
    $boundary = Get-CMBoundary -BoundaryName $item.Name
    if ($boundary -eq $null) {

        # No boundary with the name was found, so we must create one, and we will save it for later
        $boundary = New-CMBoundary -Name $item.Name -Type IPSubnet -Value $item.Subnet

        # Show progress
        Write-Host "Created new boundary for $($item.Name)"

    } else {

        # Show the user that we found an existing boundary
        Write-Host "Boundary for $($item.Name) already exists"
    }

    # Now let's find the group 
    $boundaryGroup = Get-CMBoundaryGroup -Name $item.Group
    if ($boundaryGroup -eq $null) {

        # the group was not found so we create one and save it for later
        $boundaryGroup = New-CMBoundaryGroup -Name $item.Group

        # Show progress
        Write-Host "Created boundary group for $($item.Group)"
    }

    # Now add the boundary to the group
    Add-CMBoundaryToGroup -BoundaryName $item.Name -BoundaryGroupName $item.Group

}

Write-Host "Finished..."