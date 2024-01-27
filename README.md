# Palworld Dedicated Win Server Docker

> [!IMPORTANT]
> This will run, but doesn't yet allow connections for me. It may be my setup or it may be a windows container issue
>
> AND I STILL HAD THE SAME SAVE TRANSFER ISSUE WHERE IT TRANSFERED WORLDS BUT WOULD NOT TRANSFER PLAYERS (DEFEATS THE WHOLE PURPOSE)

## Prereqs

In this case, I would not recommend windows hosting. However, I bruted forced it anyway.
If you want to do the same, you will need the following:

- Windows Pro, Enterprise, or Server editions. Home will **NOT** work
- Enable "Hyper-V" by searching in the taskbar for "windows features"
- Run [this](https://stackoverflow.com/a/68854362) in powershell
- After a few reboots, right click on the docker icon in your tray and [Switch to Windows containers](https://stackoverflow.com/a/68854362)

## Getting the damn thing to run
- Download this entire repo
- create a folder named `palworld` inside the root of the repo
- Download the palworld server on steam (should be in your library)
- copy the palworld server files under `PalServer` into the `palworld` folder you created
   > Steamcmd from the base image kept crashing on login for me,
   > so this was the only way I got it to work.
- run `docker-compose up -d` and congrats! Your server is running

## Everything else

This is only a first pass on getting it running. I havne't tried RCON or anything else. Couldn't get the barebones running and connecting. However, this is a good starting point for anyone else wanting to give it a go.

At this point you can follow the main [Readme](https://github.com/thijsvanloef/palworld-server-docker/blob/main/README.md)