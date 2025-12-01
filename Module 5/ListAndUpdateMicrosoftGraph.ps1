# Get Modulepath
$env:PSModulePath -split ';'

Get-InstalledModule -Name Microsoft.graph*
# Source: PowerShellGet
#Purpose: Lists modules that have been installed via the PowerShell Gallery (using Install-Module).
#Scope: Reads from the PowerShellGet installation database, not directly from file paths.

Get-Module -ListAvailable -Name Microsoft.graph*
# Source: Core PowerShell
# Purpose: Scans all module directories in $env:PSModulePath and lists modules that are available to be imported.
# Scope: File system–based — it doesn’t matter how the module was installed (manual copy, GitHub download, OS default, 

# Install Uninstall module from Merril
Install-Module Uninstall-Graph -Verbose

# Uninstall the uninstall module
Uninstall-Module Uninstall-Graph -AllVersions

# Uninstall Graph
Uninstall-Graph # -Verbose

# After uninstalling, close any PowerShell sessions

# Install latest module
Install-Module Microsoft.graph -Scope AllUsers -Force
