﻿# Syntax example for Import-TaskSequence.ps1 script
$TSImportFile = "E:\Demo\ExportedTaskSequences\PS100283.xml"
$NewTSName = "NEW TS Restored From Backup"

Set-Location "E:\Demo\Import and Export TS"
.\Import-TaskSequence.ps1 -SiteCode PS1 -TaskSequenceName $NewTSName -InputFile $TSImportFile 