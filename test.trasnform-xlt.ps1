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

# Validate file existence
if (-not (Test-Path $xml)) {
    Write-Host "Error: XML file '$xml' does not exist."
    exit 1
}

if (-not (Test-Path $xsl)) {
    Write-Host "Error: XSL file '$xsl' does not exist."
    exit 1
}

# Ensure output directory exists
$outputDir = Split-Path -Path $output -Parent
if (-not (Test-Path $outputDir)) {
    Write-Host "Error: Output directory '$outputDir' does not exist."
    exit 1
}

trap [Exception] {
    Write-Host "An error occurred: $($_.Exception.Message)"
    exit 1
}

# Set dotnet current directory as current path
[Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath

Write-Host "Starting XML transformation"
$xslt = New-Object System.Xml.Xsl.XslCompiledTransform
$xslt.Load($xsl)
$xslt.Transform($xml, $output)
Write-Host "XML transformation ended"