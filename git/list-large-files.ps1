param (
    [string]$Path = (Get-Location) # Default to current location if no path is specified
)

# Get files larger than 100MB, because they can not be uploaded to Github without lfs.
$largeFiles = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.Length -gt 100MB }

if ($largeFiles) {
    $largeFiles | Select-Object FullName, Length
} else {
    Write-Output "There are no files larger than 100MB in the specified path."
}
