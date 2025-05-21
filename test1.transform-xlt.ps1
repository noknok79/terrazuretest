param (
	[string]
	[Parameter(Mandatory)]
	$xml, 
	
	[string]
	[Parameter(Mandatory)]
	$xsl, 
	
	[string]
	[Parameter(Mandatory)]
	$output
)

if (-not $xml -or -not $xsl -or -not $output)
{
	Write-Host "& .\Transform-Xslt.ps1 [-xml] xml-input [-xsl] xsl-input [-output] transform-output"
	exit;
}

trap [Exception]
{
	Write-Host $_.Exception;
}

# Set dotnet current directory as current path
[Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath

Write-Host "Starting XML transformation"
$xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
$xslt.Load($xsl);
$xslt.Transform($xml, $output);
Write-Host "XML transformation ended"