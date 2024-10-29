$SiteServer = "cm01.corp.viamonstra.com"
$SiteCode = "PS1"
$TaskSequenceName = "Pre-Cache Driver Packages"

# Connect to ConfigMgr
$Namespace = "root\SMS\Site_" + $SiteCode
Import-Module (Join-Path $(Split-Path $ENV:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1) -Verbose:$false
Set-Location "$SiteCode`:"

# Create a new Task Sequence
$TS = New-CMTaskSequence -CustomTaskSequence -Name $TaskSequenceName

# Create Root Group with a condition to never run
$GroupCondition = New-CMTaskSequenceStepConditionVariable -OperatorType Equals -ConditionVariableName "NeverTrue" -ConditionVariableValue "True"
$Group = New-CMTaskSequenceGroup -Name "Pre-Cache Package Content" -Condition $GroupCondition
Add-CMTaskSequenceStep -InsertStepStartIndex 0 -TaskSequenceName $TS.Name -Step $Group 

# Create a list of driver packages to add
$Packages = Get-CMPackage -Name "Drivers*" -Fast

# Create a Download Package Content action per package
foreach ($Package in $Packages){
    # Make sure the Download Package Content action name is no longer than 50 characters
    $DCPActionName = $Package.Name
    If ($DCPActionName.Length -gt 50){ 
        $DCPActionName = ($Package.Name).Substring(0,50)
    }

    # Create each DownloadPackageContent action
    $PackageContentDrivers = New-CMTSStepDownloadPackageContent -Name $DCPActionName -AddPackage $Package
    Set-CMTaskSequenceGroup -TaskSequenceName $TS.Name -AddStep $PackageContentDrivers -InsertStepStartIndex 0 
}