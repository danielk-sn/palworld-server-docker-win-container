# start.ps1

$StartCommand = "c:\palworld\PalServer.exe"

if ($env:PORT) {
    $StartCommand += " -port=$env:PORT"
}

if ($env:PLAYERS) {
    $StartCommand += " -players=$env:PLAYERS"
}

if ($env:COMMUNITY -eq "true") {
    $StartCommand += " EpicApp=PalServer"
}

if ($env:PUBLIC_IP) {
    $StartCommand += " -publicip=$env:PUBLIC_IP"
}

if ($env:PUBLIC_PORT) {
    $StartCommand += " -publicport=$env:PUBLIC_PORT"
}

if ($env:SERVER_NAME) {
    $StartCommand += " -servername=$env:SERVER_NAME"
}

if ($env:SERVER_PASSWORD) {
    $StartCommand += " -serverpassword=$env:SERVER_PASSWORD"
}

if ($env:ADMIN_PASSWORD) {
    $StartCommand += " -adminpassword=$env:ADMIN_PASSWORD"
}

if ($env:QUERY_PORT) {
    $StartCommand += " -queryport=$env:QUERY_PORT"
}

if ($env:MULTITHREADING -eq "true") {
    $StartCommand += " -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
}

Write-Host -ForegroundColor Green "*****CHECKING FOR EXISTING CONFIG*****"

if (-not (Test-Path "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini")) {
    Write-Host -ForegroundColor Green "*****GENERATING CONFIG*****"
    ls palworld
    # Start the process and capture the process information 
    $process = Start-Process -FilePath "c:\palworld\PalServer.exe" -PassThru -Wait -NoNewWindow
    # Use Stop-Process to kill the process
    Stop-Process -Id $process.Id

    # Wait for shutdown
    Start-Sleep -Seconds 5
    Copy-Item "c:\palworld\DefaultPalWorldSettings.ini" -Destination "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
}

if ($env:RCON_ENABLED) {
    (Get-Content "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini") -replace 'RCONEnabled=[a-zA-Z]*', "RCONEnabled=$env:RCON_ENABLED" | Set-Content "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
}

if ($env:RCON_PORT) {
    (Get-Content "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini") -replace 'RCONPort=[0-9]*', "RCONPort=$env:RCON_PORT" | Set-Content "c:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
}

# Configure RCON settings
@"
host: localhost
port: $env:RCON_PORT
password: $env:ADMIN_PASSWORD
"@ | Out-File -FilePath "$env:USERPROFILE\.rcon-cli.yaml"

Write-Host -ForegroundColor Green "*****STARTING SERVER*****"
Write-Host $StartCommand

# Start the server process (adjust the executable name and path as necessary)
Start-Process -FilePath "c:\palworld\PalServer.exe" -ArgumentList $StartCommand.Split(' ') -NoNewWindow -Wait
