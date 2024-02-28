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
#Uninstall Microsoft.Graph.Authentication
$ModuleName = "Microsoft.Graph.Authentication"
$Versions = Get-Module $ModuleName -ListAvailable
Foreach ($Version in $Versions)
{
    $ModuleVersion = $Version.Version
    Write-Host "Uninstall-Module $ModuleName $ModuleVersion"
    Uninstall-Module $ModuleName -RequiredVersion $ModuleVersion
}
Install-Module Microsoft.Graph
