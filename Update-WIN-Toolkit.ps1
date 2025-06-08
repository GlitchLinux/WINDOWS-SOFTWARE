<#
.SYNOPSIS
    Windows Software Downloader Updater Utility
.DESCRIPTION
    This script updates the WINDOWS-TOOLKIT.ps1 file with the latest software categories and files
    from the GlitchLinux/WINDOWS-SOFTWARE GitHub repository.
.NOTES
    File Name      : Update-WindowsToolkit.ps1
    Prerequisite   : PowerShell 5.1 or later
#>

# Configuration
$repoUrl = "https://github.com/GlitchLinux/WINDOWS-SOFTWARE"
$rawRepoUrl = "https://raw.githubusercontent.com/GlitchLinux/WINDOWS-SOFTWARE/main/"
$toolkitPath = "WINDOWS-TOOLKIT.ps1"  # Path to your existing toolkit script
$defaultDownloadPath = "$env:USERPROFILE\Desktop\WINDOWS-SOFTWARE"

function Get-RepositoryStructure {
    try {
        Write-Host "Scanning repository structure..."
        
        # Get the main directory structure
        $mainUrl = "$repoUrl/tree/main"
        $webRequest = Invoke-WebRequest -Uri $mainUrl -UseBasicParsing
        
        # Extract folders (categories) from the page
        $categories = @{}
        $folderLinks = $webRequest.Links | Where-Object {
            $_.href -match "/tree/main/PT\d+" -and $_.class -contains "js-navigation-open"
        }
        
        foreach ($link in $folderLinks) {
            $folderName = $link.href -replace '.*/(PT\d+).*', '$1'
            $folderDescription = $link.'aria-label' -replace 'Directory ',''
            
            # Get files in this folder
            $folderUrl = "$repoUrl$($link.href)"
            $folderRequest = Invoke-WebRequest -Uri $folderUrl -UseBasicParsing
            $fileLinks = $folderRequest.Links | Where-Object {
                $_.href -match "/blob/main/PT\d+/" -and 
                $_.class -contains "js-navigation-open" -and
                -not $_.href.EndsWith("/")
            }
            
            $files = @()
            foreach ($fileLink in $fileLinks) {
                $fileName = [System.IO.Path]::GetFileName($fileLink.href)
                $fileUrl = "$rawRepoUrl$folderName/$fileName"
                $files += @{Name=$fileName; Url=$fileUrl}
            }
            
            # Use the last part of the folder name as the key (e.g., "1" for "PT1")
            $key = $folderName -replace 'PT(\d+)', '$1'
            $categories[$key] = @{
                Name = $folderName
                Description = $folderDescription
                Files = $files
            }
        }
        
        return $categories
    } catch {
        Write-Host "Error scanning repository: $_" -ForegroundColor Red
        return $null
    }
}

function Update-ToolkitScript {
    param (
        [hashtable]$categories,
        [string]$toolkitPath
    )
    
    try {
        Write-Host "Updating toolkit script..."
        
        # Read the original script
        $scriptContent = Get-Content -Path $toolkitPath -Raw
        
        # Find the categories hashtable in the script
        $startMarker = '# Create a hashtable to map the folder structure with direct download links'
        $endMarker = '# Additional configuration'
        
        $startIndex = $scriptContent.IndexOf($startMarker)
        $endIndex = $scriptContent.IndexOf($endMarker)
        
        if ($startIndex -eq -1 -or $endIndex -eq -1) {
            throw "Could not locate the categories section in the script"
        }
        
        # Build the new categories section
        $newCategoriesSection = @"
# Create a hashtable to map the folder structure with direct download links
`$categories = @{
"@

        foreach ($key in $categories.Keys | Sort-Object) {
            $category = $categories[$key]
            $newCategoriesSection += @"
    "$key" = @{ 
        Name = "$($category.Name)"; 
        Description = "$($category.Description)";
        Files = @(
"@
            
            foreach ($file in $category.Files) {
                $newCategoriesSection += @"
            @{Name="$($file.Name)"; Url="$($file.Url)"},
"@
            }
            
            $newCategoriesSection += @"
        )
    }
"@
        }
        
        $newCategoriesSection += @"
}
"@
        
        # Replace the old section with the new one
        $beforeSection = $scriptContent.Substring(0, $startIndex)
        $afterSection = $scriptContent.Substring($endIndex)
        $updatedScript = $beforeSection + $newCategoriesSection + $afterSection
        
        # Create a backup of the original file
        $backupPath = "$toolkitPath.backup_$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item -Path $toolkitPath -Destination $backupPath
        
        # Write the updated script
        Set-Content -Path $toolkitPath -Value $updatedScript -Force
        
        Write-Host "Toolkit script updated successfully!" -ForegroundColor Green
        Write-Host "Backup created at: $backupPath" -ForegroundColor Yellow
        
        return $true
    } catch {
        Write-Host "Error updating toolkit script: $_" -ForegroundColor Red
        return $false
    }
}

function Show-UpdateSummary {
    param (
        [hashtable]$categories
    )
    
    Clear-Host
    Write-Host "============================================="
    Write-Host "       UPDATE SUMMARY                        "
    Write-Host "============================================="
    Write-Host "Repository: $repoUrl"
    Write-Host "Detected categories: $($categories.Count)"
    Write-Host "---------------------------------------------"
    
    foreach ($key in $categories.Keys | Sort-Object) {
        $category = $categories[$key]
        Write-Host " $($category.Name): $($category.Description)"
        Write-Host "   Files: $($category.Files.Count)"
    }
    
    Write-Host "============================================="
    $confirm = Read-Host "Proceed with update? (y/n)"
    return $confirm -eq 'y'
}

# Main execution
Clear-Host
Write-Host "============================================="
Write-Host "   WINDOWS SOFTWARE DOWNLOADER UPDATER      "
Write-Host "============================================="
Write-Host "This script will update the WINDOWS-TOOLKIT.ps1"
Write-Host "file with the latest software from the repo."
Write-Host "---------------------------------------------"

# Verify the toolkit file exists
if (-not (Test-Path -Path $toolkitPath)) {
    Write-Host "Error: Could not find WINDOWS-TOOLKIT.ps1 at $toolkitPath" -ForegroundColor Red
    exit 1
}

# Get the latest repository structure
$categories = Get-RepositoryStructure
if (-not $categories) {
    Write-Host "Failed to retrieve repository structure." -ForegroundColor Red
    exit 1
}

# Show summary and confirm
if (-not (Show-UpdateSummary -categories $categories)) {
    Write-Host "Update cancelled by user." -ForegroundColor Yellow
    exit 0
}

# Update the toolkit script
$success = Update-ToolkitScript -categories $categories -toolkitPath $toolkitPath
if ($success) {
    Write-Host "Update completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Update failed." -ForegroundColor Red
    exit 1
}
