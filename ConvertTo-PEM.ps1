<#
.SYNOPSIS

Convert an X.509 certeificate from CER (DER) format to PEM format.

.DESCRIPTION

Converts the specified X.509 certificate from CER (DER) format to
PEM (base 64) format.

.NOTES


Copyright 2020, The Migus Group, LLC. All rights reserved
#>

[CmdletBinding(DefaultParameterSetName = 'Input')]
Param(
  [Parameter(Mandatory = $true, ParameterSetName = 'Input', Position = 0)]
  [Parameter(Mandatory = $true, ParameterSetName = 'Pipeline', ValueFromPipeline = $true)]
  [System.Security.Cryptography.X509Certificates.X509Certificate2]
  $Certificate,
  [Parameter(ParameterSetName = "Input", Position = 1)]
  [Parameter(ParameterSetName = "Pipeline", Position = 0)]
  $OutFilePath
)

$Output = New-Object System.Text.StringBuilder
[void]$Output.AppendLine("-----BEGIN CERTIFICATE-----")
[void]$Output.AppendLine([System.Convert]::ToBase64String($Certificate.RawData, 1))
[void]$Output.AppendLine("-----END CERTIFICATE-----")

if ($null -ne $OutFilePath) {
    $Output.ToString() | Out-File -Encoding UTF8 -FilePath $OutFilePath -NoClobber -NoNewline
} else {
    $Output.ToString() | Out-String -NoNewline
}
