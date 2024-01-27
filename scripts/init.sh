# init.ps1

# Check if PUID and PGID are not set to 0
if ($env:PUID -ne "0" -and $env:PGID -ne "0") {
    Write-Host -ForegroundColor Green "*****EXECUTING USERMOD*****"
    # Windows doesn't support usermod/groupmod, consider implementing alternative user handling if needed
} else {
    Write-Host -ForegroundColor Red "Running as root is not supported, please fix your PUID and PGID!"
    exit 1
}

# Create directories and set ownership (adjust as needed for Windows)
New-Item -ItemType Directory -Force -Path "C:\palworld\backups"
# Ownership setting is not typically done in Windows as in Linux

# Update on boot
if ($env:UPDATE_ON_BOOT -eq "true") {
    Write-Host -ForegroundColor Green "*****STARTING INSTALL/UPDATE*****"
    # Update the following line to match your Windows-based update process
    & C:\steamcmd\steamcmd.exe +force_install_dir "C:\palworld" +login anonymous +app_update 2394010 validate +quit
}

# Define termination handler (needs adjustment for Windows)
function term_handler {
    if ($env:RCON_ENABLED -eq "true") {
        # Adjust these commands for your Windows environment
        & rcon-cli save
        & rcon-cli shutdown 1
    } else {
        # Adjust process termination command for Windows
        Stop-Process -Name "PalServer" -Force
    }
}

# Setup a trap to handle script termination
trap { term_handler }

# Start the server (update this line to match your Windows server startup command)
Start-Process "C:\path\to\start.ps1" -NoNewWindow -PassThru
wait-process -Name "PalServer"
