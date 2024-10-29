# Script that purposely breaks
try { 
    Get-WinEvent -LogName "Microsoft-Windows-Bran77chCache/Operational" -ErrorAction Stop | Where-Object {$_.ID -eq 13}
}
catch [Exception] {
    Write-Host "Hmmm"
    if ($_.Exception -match "There is not an event log") {
        #Write-Log " No BranchCache Event Log found, exiting" 
        Write-Warning " No BranchCache Event Log found, exiting" 
    #Exit 0
    }
}