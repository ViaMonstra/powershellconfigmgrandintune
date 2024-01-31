# Specify the folder path where you want to search for Word documents
$folderPath = "E:\demo"

# Use Get-ChildItem to list all files in the specified folder with .docx extension
$wordDocuments = Get-ChildItem -Path $folderPath -Fillter *.docx -Recurse

# Loop through the Word documents and display their names
foreach ($doc in $wordDocuments) {
    Write-Host "Found Word Document: $($doc.Name)"
}
