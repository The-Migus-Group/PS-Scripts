<#
.SYNOPSIS

Create a self-signed RSA certificate

.DESCRIPTION

Generates a self-signed X.509 certificate using the RSA and AES Provider then
exports the Certificate to a CER file and the Certificate Chain and Private Key
to a PFX file.

.NOTES
The script must be run with Administrator privileges.


Copyright 2020, The Migus Group, LLC. All rights reserved
#>
[CmdletBinding()]
Param(
  # A list of Subject Alternative Names (SANs) to add to the certificate
  [Parameter(Mandatory = $true, Position = 0)][string[]] $SubjectAlternativeNames,

  # The expiration date of the certificate expressed as "years from now."
  [Parameter(Position = 1)][ValidateScript( { $_ -ge 1 })][int] $ExpirationInYears = 10,

  # The hashing algorithm to use
  [Parameter(Position = 2)][ValidateScript( { $_ -in "SHA256", "SHA512" })][string] $HashAlgorithm = "SHA256",

  # The cryptographic key length
  [Parameter(Position = 3)][ValidateScript( { $_ -ge 2048 })][int] $KeyLength = 4096,

  # The DNS name to be used as the Subject of the certificate
  [Parameter(Position = 4)][string] $MyDnsName = ${env:COMPUTERNAME},

  # The Cryptographic Provider to use
  [string] $CryptoProvider = "Microsoft Enhanced RSA and AES Cryptographic Provider",

  # The path of the file to which the resulting certificate will be exported
  [string] $CertificateFilePath = "${env:COMPUTERNAME}.cer",

  # The PFX file that will contain the certificate chain and key
  [string] $PfxFilePath = "${env:COMPUTERNAME}.pfx",

  # The (mandatory) password on the PFX file
  [SecureString] $PfxPassword = (ConvertTo-SecureString $env:COMPUTERNAME -AsPlainText -Force)
)

$ErrorActionPreference = 'Stop' # Each step requires the last

# Purely for readability
$NewSelfSignedCertificateParamters = @{
  DnsName = $SubjectAlternativeNames
  HashAlgorithm = $HashAlgorithm
  KeyLength = $keyLength
  NotAfter = (Get-Date).AddYears($ExpirationInYears)
  Provider = $CryptoProvider
  Subject = $MyDnsName
}

# Create the self-signed certificate
$Certificate = New-SelfSignedCertificate @NewSelfSignedCertificateParamters

# Export the certificate
Export-Certificate -Cert $Certificate -FilePath $CertificateFilePath

# Export the PFX
Export-PfxCertificate -Cert $Certificate -FilePath $PfxFilePath -Password $PfxPassword
