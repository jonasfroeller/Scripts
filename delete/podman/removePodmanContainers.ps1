# Unregister podman wsl
wsl --unregister podman-machine-default
# Stop any running WSL instances
wsl --shutdown
# Take ownership of the directory
takeown /F "$env:USERPROFILE\.local\share\containers\podman" /R
# Grant full control permissions
icacls "$env:USERPROFILE\.local\share\containers\podman" /grant "$($env:USERNAME):F" /T
# Try to remove the directory (hopefully works, it did not for me, but it might work for you)
Remove-Item -Recurse -Force "$env:USERPROFILE\.local\share\containers\podman"
