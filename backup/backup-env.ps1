$SourceDir = Get-Location
$SourcePath = $SourceDir.Path + "\"  # Ensure trailing backslash

# Get the actual Downloads folder path from the Windows Shell (not the default one, but the one that is actually being used)
$shell = New-Object -ComObject Shell.Application
$downloadsFolder = $shell.NameSpace('shell:Downloads').Self.Path
$BackupDir = Join-Path $downloadsFolder "env-backup"

$ExcludedDirs = @(
    'node_modules'
)

Write-Output "Excluding directories matching: $($ExcludedDirs -join ', ')"

if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
    Write-Output "Created backup directory: $BackupDir"
}

# Recursively find all .env files and back them up, excluding specified directories
Get-ChildItem -Path $SourceDir -Filter ".env" -Recurse -File | Where-Object {
    # Check if any part of the path contains excluded directories
    $pathParts = $_.FullName.Split([IO.Path]::DirectorySeparatorChar)
    -not ($pathParts | Where-Object { $ExcludedDirs -contains $_ })
} | ForEach-Object {
    # Calculate the relative path from the source directory
    $relativePath = $_.FullName.Substring($SourcePath.Length)
    
    # Build the destination path by combining backup directory and relative path
    $destinationPath = Join-Path $BackupDir $relativePath
    
    $destinationDir = Split-Path $destinationPath -Parent
    if (!(Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }
    
    # Check for collision and create a versioned filename if needed
    if (Test-Path $destinationPath) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $extension = [System.IO.Path]::GetExtension($_.Name)
        $destinationPath = Join-Path $destinationDir "$baseName`_$timestamp$extension"
        Write-Output "File exists. Backing up as: $destinationPath"
    }
    else {
        Write-Output "Backing up file: $($_.FullName) to $destinationPath"
    }
    
    # Create parent directory if it doesn't exist
    $destDir = Split-Path -Path $destinationPath -Parent
    if (!(Test-Path -Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    
    Copy-Item -Path $_.FullName -Destination $destinationPath -Force
}

Write-Output "Backup complete. All .env files have been copied to: $BackupDir"
Read-Host -Prompt "Press Enter to exit"
