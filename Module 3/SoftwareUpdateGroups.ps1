#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#
# This script was auto-generated at '11/2/2022 3:13:29 PM'.

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

$SUGs = Get-CMSoftwareUpdateGroup -Name '*Windows 11 Clients*'

Foreach ($item in $SUGs) {

    Write-Host $item.LocalizedDisplayName

    $NewName = 'Windows 11 - Patch Tuesday ' + ($item.DateCreated.ToString('yyyy-MM MMMM'))

    Set-CMSoftwareUpdateGroup -InputObject $item -NewName $NewName

}