# start.ps1

$StartCommand = ".\PalServer.exe"

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

Set-Location "C:\palworld"

Write-Host -ForegroundColor Green "*****CHECKING FOR EXISTING CONFIG*****"

if (-not (Test-Path "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini")) {
    Write-Host -ForegroundColor Green "*****GENERATING CONFIG*****"

    # Server will generate all ini files after first run. Adjust the executable name and path as necessary.
    Start-Process ".\PalServer.exe" -ArgumentList "" -Wait -NoNewWindow

    # Wait for shutdown
    Start-Sleep -Seconds 5
    Copy-Item "C:\palworld\DefaultPalWorldSettings.ini" -Destination "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
}

if ($env:RCON_ENABLED) {
    (Get-Content "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini") -replace 'RCONEnabled=[a-zA-Z]*', "RCONEnabled=$env:RCON_ENABLED" | Set-Content "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
}

if ($env:RCON_PORT) {
    (Get-Content "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini") -replace 'RCONPort=[0-9]*', "RCONPort=$env:RCON_PORT" | Set-Content "C:\palworld\Pal\Saved\Config\WindowsServer\PalWorldSettings.ini"
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
Start-Process ".\PalServer.exe" -ArgumentList $StartCommand.Split(' ') -NoNewWindow -Wait
