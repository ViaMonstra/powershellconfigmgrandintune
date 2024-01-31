# Get Devices
Get-CMDevice -Name * -Fast

# Get Task Sequences and show their name and boot image
Get-CMTaskSequence | Select Name, BootimageID

# List ConfigMgr cmdlets
Get-Command -Name * -Module ConfigurationManager