# Use steamcmd/steamcmd base image for Windows
FROM steamcmd/steamcmd:windows-core

# Use PowerShell as the default shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV chocolateyVersion=1.4.0

# Switch to Container Administrator for installing Chocolatey
USER ContainerAdministrator

# Update and install necessary packages (example with Chocolatey)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install wget -y;

# Set the working directory
WORKDIR C:/

# Download and install rcon-cli
RUN wget 'https://github.com/itzg/rcon-cli/releases/download/1.6.4/rcon-cli_1.6.4_windows_amd64.tar.gz' -OutFile 'rcon-cli.tar.gz'; \
    tar -zxvf rcon-cli.tar.gz *.exe; \
    Remove-Item 'rcon-cli.tar.gz';

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
    UPDATE_ON_BOOT=false \
    RCON_ENABLED=false \
    RCON_PORT=25575 \
    QUERY_PORT=27015 \
    TZ=UTC

# Copy scripts
COPY ./scripts/* C:/server/
RUN Set-ExecutionPolicy Unrestricted; \
    Get-ChildItem -Path C:/server/*.ps1 | ForEach-Object { Unblock-File $_.FullName }

# Revert to the default user
USER ContainerUser

# Health check
HEALTHCHECK --start-period=5m \
    CMD powershell -command "if (Get-Process PalServer -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"

# # Expose ports
EXPOSE ${PORT} ${RCON_PORT}

# Entry point (might need to be updated for Windows)
ENTRYPOINT ["powershell", "C:/server/init.ps1"]