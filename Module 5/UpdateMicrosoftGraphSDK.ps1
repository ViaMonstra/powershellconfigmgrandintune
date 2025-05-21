# Remove any depending modules
$Modules = Get-Module Microsoft.Entra* -ListAvailable | Select-Object Name -Unique
Foreach ($Module in $Modules)
{
    $ModuleName = $Module.Name
    $Versions = Get-Module $ModuleName -ListAvailable
    Foreach ($Version in $Versions)
    {
        $ModuleVersion = $Version.Version
        Write-Host "Uninstall-Module $ModuleName $ModuleVersion"
        Uninstall-Module $ModuleName -RequiredVersion $ModuleVersion
    }
}

# Remove existing Microsoft.Graph modules
$Modules = Get-Module Microsoft.Graph* -ListAvailable | Where {$_.Name -ne "Microsoft.Graph.Authentication"} | Select-Object Name -Unique
Foreach ($Module in $Modules)
{
    $ModuleName = $Module.Name
    $Versions = Get-Module $ModuleName -ListAvailable
    Foreach ($Version in $Versions)
    {
        $ModuleVersion = $Version.Version
        Write-Host "Uninstall-Module $ModuleName $ModuleVersion"
        Uninstall-Module $ModuleName -RequiredVersion $ModuleVersion
    }
}

# Uninstall Microsoft.Graph.Authentication
$ModuleName = "Microsoft.Graph.Authentication"
$Versions = Get-Module $ModuleName -ListAvailable
Foreach ($Version in $Versions)
{
    $ModuleVersion = $Version.Version
    Write-Host "Uninstall-Module $ModuleName $ModuleVersion"
    Uninstall-Module $ModuleName -RequiredVersion $ModuleVersion
}

# Install the latest version (you may have to close all PowerShell before upgrading)
Install-Module Microsoft.Graph -Force

# If removed any dependency modules, reinstall them again
Install-Module Microsoft.Entra -Force
