# Deploy Code Signing Certificate with Intune
# https://www.wpninjas.ch/2020/09/deploy-code-signing-certificate-with-intune/
#
# Modified with longer validity period and increased security

$ValidityPeriod = 5 # years
$Date = Get-Date
$ValidityPeriodDate = $Date.AddYears($ValidityPeriod)
$KeyLength = 3072 

$workingDir = "E:\Demo\Intune\CodeSigningCertificates"

$SSCArguments = @{ 
    Type = "CodeSigningCert" 
    Subject = "CN=ViaMonstraLab" 
    KeyUsage = "DigitalSignature" 
    FriendlyName = "ViaMonstra Code Lab" 
    CertStoreLocation = "cert:\CurrentUser\my" 
    NotAfter = $ValidityPeriodDate
    KeyLength = $KeyLength
    } 
$mycert = New-SelfSignedCertificate @SSCArguments

Export-Certificate -Cert $mycert.PSPath -FilePath "$workingDir\CodeSignCert.cer"