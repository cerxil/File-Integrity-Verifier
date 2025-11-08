$Host.UI.RawUI.WindowTitle = "File Integrity Verifier"

function Get-FilePath {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Select the file to verify"
    $dialog.Filter = "All files (*.*)|*.*"
    $dialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $dialog.FileName
    } else {
        Write-Host "No file selected. Exiting." -ForegroundColor Red
        exit
    }
}

function Wait-ForFileDownload {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Host "File not found: $Path" -ForegroundColor Red
        exit
    }

    $dir = Split-Path $Path
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $tempExtensions = @(".part", ".crdownload", ".tmp")

    # Wait for temp files to disappear
    $iteration = 0
    while ($true) {
        $activeTemps = @()
        foreach ($ext in $tempExtensions) {
            $activeTemps += Get-ChildItem -Path $dir -Filter "*$ext" -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -like "$baseName*${ext}" }
        }

        if ($activeTemps.Count -eq 0) { break }

        $iteration++
        $status = "Waiting for downloads to finish..."
        $progressPercent = [Math]::Min($iteration * 5, 100)
        $tempNames = ($activeTemps | ForEach-Object { $_.Name }) -join ", "
        Write-Progress -Activity $status -Status ("Detected temporary files: $tempNames") -PercentComplete $progressPercent
        Start-Sleep -Seconds 2
    }

    Write-Progress -Activity "Waiting for downloads" -Completed -Status "Done"
    Write-Host "Temporary files removed — continuing..."

    # Wait for file size to stabilize
    $previousSize = (Get-Item $Path).Length
    $iteration = 0
    while ($true) {
        Start-Sleep -Seconds 2
        $currentSize = (Get-Item $Path).Length
        if ($currentSize -eq $previousSize) { break }

        $iteration++
        $status = "Waiting for file size to stabilize..."
        $progressPercent = [Math]::Min($iteration * 5, 100)
        Write-Progress -Activity $status -Status ("Current size: $currentSize bytes") -PercentComplete $progressPercent
        $previousSize = $currentSize
    }

    Write-Progress -Activity "File size check" -Completed -Status "Done"
    Write-Host "File size stable. Ready for verification."
}

# ====== MAIN SCRIPT ======


Write-Host "File Integrity Verifier" -ForegroundColor Cyan
Write-Host "Please use the Explorer window to select the file you want to verify the hash for."
Write-Host ""

# Step 1: Select file
$filePath = Get-FilePath

# Step 2: Enter expected hash
$expectedHash = Read-Host "Paste expected hash for the selected file`n[Tip: Right-click in the terminal to paste]"

# Step 3: Auto-detect algorithm
$hashLength = $expectedHash.Length
switch ($hashLength) {
    32 { $algorithm = "MD5" }
    40 { $algorithm = "SHA1" }
    64 { $algorithm = "SHA256" }
    128 { $algorithm = "SHA512" }
    default {
        Write-Host "Could not automatically determine hash type. Using SHA256 by default." -ForegroundColor Yellow
        $algorithm = "SHA256"
    }
}
Write-Host "Detected hash algorithm: $algorithm" -ForegroundColor Green

# Step 4: Wait for download completion and size stabilization
Wait-ForFileDownload -Path $filePath

# Step 5: Compute hash
Write-Host "`nCalculating $algorithm hash..." -ForegroundColor Yellow
try {
    $fileHash = (Get-FileHash -Path $filePath -Algorithm $algorithm).Hash.ToLower()
} catch {
    Write-Host "Error calculating hash: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Step 6: Show results
Write-Host ""
Write-Host "==================== RESULTS ====================" -ForegroundColor Cyan
Write-Host ("Expected Hash : " + $expectedHash.ToLower()) -ForegroundColor White
Write-Host ("Computed Hash : " + $fileHash) -ForegroundColor White
Write-Host ""

# Step 7: Compare
if ($fileHash -eq $expectedHash.ToLower()) {
    Write-Host "`nResult: MATCH - File verified authentic." -ForegroundColor Green
} else {
    Write-Host "`nResult: HASH MISMATCH - File may be corrupted or tampered." -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor DarkGray
[void][System.Console]::ReadKey($true)
