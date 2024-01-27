# Use steamcmd/steamcmd base image for Windows
FROM steamcmd/steamcmd:windows-core

# Use PowerShell as the default shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Update and install necessary packages (example with Chocolatey)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install wget -y;

# Download and install rcon-cli
RUN wget 'https://github.com/itzg/rcon-cli/releases/download/1.6.4/rcon-cli_1.6.4_windows_amd64.zip' -OutFile 'rcon-cli.zip'; \
    Expand-Archive 'rcon-cli.zip' -DestinationPath 'C:\'; \
    Remove-Item 'rcon-cli.zip'; \
    Move-Item 'C:\rcon-cli_1.6.4_windows_amd64\rcon-cli.exe' 'C:\Windows\System32\rcon-cli.exe'; \
    Remove-Item -Recurse -Force 'C:\rcon-cli_1.6.4_windows_amd64';

# Set environment variables
ENV PORT= \
    PUID=1000 \
    PGID=1000 \
    PLAYERS= \
    MULTITHREADING=false \
    COMMUNITY=false \
    PUBLIC_IP= \
    PUBLIC_PORT= \
    SERVER_PASSWORD= \
    SERVER_NAME= \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true \
    RCON_ENABLED=true \
    RCON_PORT=25575 \
    QUERY_PORT=27015 \
    TZ=UTC

# Copy scripts
COPY ./scripts/* C:/server/
RUN Set-ExecutionPolicy Unrestricted; \
    Get-ChildItem -Path C:/home/steam/server/*.ps1 | ForEach-Object { Unblock-File $_.FullName }

# Set the working directory
WORKDIR C:/server

# Health check (needs to be updated for Windows)
HEALTHCHECK --start-period=5m \
    CMD powershell -command "if (Get-Process PalServer-Windows -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"


# Expose ports
EXPOSE ${PORT} ${RCON_PORT}

# Entry point (might need to be updated for Windows)
ENTRYPOINT ["C:/server/init.ps1"]