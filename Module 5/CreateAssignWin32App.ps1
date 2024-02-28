#Create Application
Connect-MSIntuneGraph -TenantID "corp.viamonstra.com"

$Name = 'Notepad++ 8.5.8 x64 - PowerShell Demo'
$Description = 'Text Editor'
$Publisher = 'Don Ho'
$packagePath = 'D:\Intune\Win32Apps\Notepad++\Package'
$File = 'npp.8.5.8.Installer.x64.intunewin'
$InstallationParameters = 'npp.8.5.8.Installer.x64.exe /S'
$UninstallationCommand = '"%ProgramFiles%\Notepad++\uninstall.exe" /S"'
$installedPath = "%ProgramFiles%\Notepad++"
$installedName = "notepad++.exe"
$Version = '8.5.8'

$detectionRule = New-IntuneWin32AppDetectionRuleFile -Existence -Path $installedPath -FileOrFolder $installedName -Check32BitOn64System $false -DetectionType "exists"
$requirementRule = New-IntuneWin32AppRequirementRule -Architecture x64 -MinimumSupportedWindowsRelease W10_2004

Add-IntuneWin32App -FilePath (Join-Path -Path $packagePath -ChildPath $File) `
    -DisplayName $Name `
    -Description $Description `
    -Publisher $Publisher `
    -InstallExperience system `
    -RestartBehavior suppress `
    -DetectionRule $detectionRule `
    -RequirementRule $requirementRule `
    -InstallCommandLine $InstallationParameters `
    -UninstallCommandLine $UninstallationCommand `
    -AppVersion $Version `
    -Verbose

#Create Entra group and add a user
#Find-MgGraphCommand -command Get-MgUser | Select -First 1 -ExpandProperty Permissions

$Scopes = @(
    "User.ReadWrite.All"
    "Group.ReadWrite.All"
)
$TenantID = ""
$Tenant = Connect-MgGraph -TenantId $TenantID -Scopes $Scopes

$groupName = "sg-usr-Notepad++ (Available) - PowerShell Demo"
$groupNickname = "notepadplusplus"
$userId = Get-MgUser -UserId "user@viamonstra.com"

$newAppGroup = New-MgGroup -DisplayName $groupName -MailEnabled:$False -MailNickname $groupNickname -SecurityEnabled
New-MgGroupMember -GroupId $newAppGroup.Id -DirectoryObjectId $userId.Id

#Assign Win32App to new Entra group
$App = Get-IntuneWin32App -DisplayName $Name
Add-IntuneWin32AppAssignmentGroup -Include -GroupID $newAppGroup.Id -ID $app.id -Intent available -DeliveryOptimizationPriority foreground
