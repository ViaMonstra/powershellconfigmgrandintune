# Site configuration
$SiteCode = "PS1" # Site code 
$ProviderMachineName = "cm01.corp.admlabs.net" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if ((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if ((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams


#$ApplicationName = "7-Zip 23.01"
#$ApplicationDescription = "Archive Utility"
#$CollectionName = "7-Zip 23.01"
#$MSILocation = "\\fs01.corp.admlabs.net\content\Applications\7zip\7-zip v23.01 MSI\7z2301-x64.msi"

$ApplicationName = "VLC 3.0.16"
$ApplicationDescription = "Media Player"
$CollectionName = "VLC 3.0.16"
$MSILocation = "\\fs01.corp.admlabs.net\content\Applications\VLC\VLC v3.0.16 MSI\vlc-3.0.16-win64.msi"


# Create the application
New-CMApplication -Name $ApplicationName -Description $ApplicationDescription -AutoInstall $true -Verbose
Add-CMMsiDeploymentType -ApplicationName $ApplicationName  -ContentLocation $MSILocation -InstallationBehaviorType InstallForSystem -Verbose

# Distribute the content
Start-CMContentDistribution -ApplicationName $ApplicationName -DistributionPointGroupName "On-Prem Distribution Points" -Verbose

# Create Collection
New-CMCollection -Name $CollectionName -CollectionType Device -LimitingCollectionName "All Workstations"

# Deploy the application
New-CMApplicationDeployment -CollectionName $CollectionName -Name $ApplicationName -DeployAction Install -DeployPurpose Available -UserNotification DisplayAll -AvailableDateTime (get-date) -TimeBaseOn LocalTime

# Add PC0008 to collection
$Machine = "AJ-OPTIPLEX3060"
Add-CMDeviceCollectionDirectMembershipRule -CollectionName $ApplicationName -ResourceID (Get-CMDevice -Name $Machine).ResourceID -Verbose
