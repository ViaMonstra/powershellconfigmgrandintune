
# Site configuration
$SiteCode = "PS1" # Site code 
$ProviderMachineName = "cm01.corp.admlabs.net" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if ($null -eq (Get-Module ConfigurationManager)) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if ($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

#------------------

# Define Filter for SUG Names
$NameFilter = "*Windows 11 Clients*"
$BaseGroupName = "Base Windows 11 Updates"
$OlderThanDate = (Get-Date).AddMonths(-1)

# Get All Software Update Groups
$AllSoftwareUpdateGroups = Get-CMSoftwareUpdateGroup -Name $NameFilter

$OldSoftwareUpdateGroups = $AllSoftwareUpdateGroups | Where-Object { $_.DateCreated -le $OlderThanDate }

Foreach ($SUG in $OldSoftwareUpdateGroups) {

    Write-Host -ForegroundColor Green $sug.LocalizedDisplayName

    if ($SUG.NumberOfUpdates -gt 0 ) {
        $Updates = Get-CMSoftwareUpdate -UpdateGroupId $SUG.CI_ID -Fast -DisableWildcardHandling 
        Write-Host "Moving $($Updates.Count) Updates to $BaseGroupName"
        $Updates | Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $BaseGroupName
        $Updates | Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateGroupId  $SUG.CI_ID -Force:$true

    }
    else {
        Write-Host "No updates in Software Update Group - Removing it"

        $LockState = Get-CMObjectLockDetails -InputObject $SUG
        if ($LockState.LockState -ne 0) {
            Unlock-CMObject -InputObject $SUG -Force
        }

        Remove-CMSoftwareUpdateGroup -Id $sug.CI_ID -Force 
    }

}

