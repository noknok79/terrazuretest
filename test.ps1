# Requires -Version 3.0 
# 
# Requirements:
# - Azure DevOps Permissions
#   - Project Collection Build Service on Azure DevOps Wiki Repository needs Contribute Allow.

<#
  .SYNOPSIS
  Add pages to a Azure DevOps wiki.

  .DESCRIPTION
  The Upload-Wiki.ps1 script Add new pages to a Azure DevOps wiki.

  .INPUTS
  None. You cannot pipe objects to Upload-Wiki.ps1.

  .OUTPUTS
  None. But a new wiki page would hopefully be created.

  .EXAMPLE
  PS> .\Upload-Wiki.ps1 -organization FMC-Digital-Program -project 'PD HTA' -wiki WikiAutomated -path '/test.md' -file './test.md'

#>
param (
    [string]
    # The name of the Azure DevOps organization
    [Parameter(Mandatory)]
    $organization,

    [string]
    # Project ID or project name
    [Parameter(Mandatory)]
    $project,

    [string]
    # Wiki Id or name
    [Parameter(Mandatory)]
    $wiki,

    [string]
    # Wiki page path
    [Parameter(Mandatory)]
    $path,

    [string]
    # File to upload
    [Parameter(Mandatory)]
    $file,

    [string]
    # Comment to be associated with the page operation
    $comment = 'Automated commit',

    [string]
    # Personal Access Token. If not set, $SYSTEM_ACCESSTOKEN env variable will be used instead
    $PAT
)

Add-Type -AssemblyName System.Web
$encodedOrg = [System.Uri]::EscapeDataString($organization)
$encodedProj = [System.Uri]::EscapeDataString($project)
$encodedPath = [System.Uri]::EscapeDataString($path)
$encodedComment = [System.Uri]::EscapeDataString($comment)

$uri = "https://dev.azure.com/$encodedOrg/$encodedProj/_apis/wiki/wikis/$wiki/pages?path=$encodedPath&comment=$encodedComment&versionDescriptor.version=main&versionDescriptor.versionType=branch&api-version=7.1"

if ($PAT) {
    $Header = @{
        'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT"))
    }
} else {
    $Header = @{
        'Authorization' = ('Bearer {0}' -f $env:SYSTEM_ACCESSTOKEN)
    }
}

# Load content file
[string]$content = Get-Content $file -Raw

$params = @{
    Uri         = $uri
    Headers     = $Header
    Method      = 'Put'
    ContentType = 'application/json; charset=utf-8'
    Body        = @{ content = $content } | ConvertTo-Json -Depth 3
}

# Log the URI and request body for debugging
Write-Host "Calling URI: $uri"
Write-Host "Request Body: $($params['Body'])"

# Invoke the call
try {
    $response = Invoke-WebRequest @params
    Write-Host "✅ Page uploaded successfully."
} catch {
    Write-Error "❌ Upload failed: $($_.Exception.Message)"

    try {
        $errorResponse = $_.Exception.Response
        if ($errorResponse -ne $null) {
            $reader = [System.IO.StreamReader]::new($errorResponse.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Server response body:"
            Write-Host "$responseBody"
        } else {
            Write-Error "No response stream available."
        }
    } catch {
        Write-Error "Could not extract error response: $($_.Exception.Message)"
    }
}