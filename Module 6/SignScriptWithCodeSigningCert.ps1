$signingcert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object {$_.Subject -eq "CN=ViaMonstraLab"}

$signingcert | Select *

$ScriptToSign = "E:\Demo\Intune\Scripts\ScriptToSign.ps1"

Set-AuthenticodeSignature -Certificate $signingcert -FilePath $ScriptToSign

