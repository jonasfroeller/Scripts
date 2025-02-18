# Check GPU Info
function Get-GPUInfo {
    $gpus = Get-WmiObject Win32_VideoController
    foreach ($gpu in $gpus) {
        Write-Output "GPU: $($gpu.Name)"
        Write-Output "VRAM: $([math]::Round($gpu.AdapterRAM / 1GB, 2)) GB"
    }
}

# Check RAM Info
function Get-RAMInfo {
    $ram = Get-WmiObject Win32_ComputerSystem
    Write-Output "Total RAM: $([math]::Round($ram.TotalPhysicalMemory / 1GB, 2)) GB"
}

# Check Disk Space (All Fixed Disks)
function Get-DiskInfo {
    $disks = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }  # 3 = Fixed Disk
    foreach ($disk in $disks) {
        $totalGB = [math]::Round($disk.Size / 1GB, 2)
        $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
        $usedGB = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
        $freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
        
        Write-Output "Drive $($disk.DeviceID)"
        Write-Output "  Total Space: $totalGB GB"
        Write-Output "  Used Space: $usedGB GB"
        Write-Output "  Free Space: $freeGB GB"
        Write-Output "  Free Space Percentage: $freePercent%"
    }
}

# Check CPU Info
function Get-CPUInfo {
    $cpu = Get-WmiObject Win32_Processor
    Write-Output "CPU: $($cpu.Name)"
    Write-Output "Cores: $($cpu.NumberOfCores)"
    Write-Output "Threads: $($cpu.NumberOfLogicalProcessors)"
    Write-Output "Max Clock Speed: $($cpu.MaxClockSpeed) MHz"
}

# Run all checks
Write-Output "Checking System Specifications..."
Write-Output "-----------------------------------------------"
Get-GPUInfo
Write-Output "-----------------------------------------------"
Get-RAMInfo
Write-Output "-----------------------------------------------"
Get-DiskInfo
Write-Output "-----------------------------------------------"
Get-CPUInfo
Write-Output "-----------------------------------------------"
Write-Output "System Check Complete!"
