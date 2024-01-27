# backup.ps1

if ($env:RCON_ENABLED -eq "true") {
    & rcon-cli save
}

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$FilePath = "C:\palworld\backups\palworld-save-$Date.zip"
$SourceDir = "C:\palworld\Pal\Saved"

# Ensure backup directory exists
$BackupDir = "C:\palworld\backups"
If (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir
}

# Change to the source directory
Set-Location $SourceDir

# Create the backup
Compress-Archive -LiteralPath "Saved" -DestinationPath $FilePath

Write-Host "Backup created at $FilePath"
