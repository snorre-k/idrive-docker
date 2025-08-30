> [!WARNING]
> Upgrading to version 3.9.0 and following versions of the iDrive client does not work correctly. Please have a look at [Issue #26](/../../issues/26)

# idrive-docker
Run IDrive Linux Client in a docker container

GitHub: https://github.com/snorre-k/idrive-docker

## Requirements
- Docker installed
- optional: docker-compose 
- IDrive account

## Build image
```shell
docker build -t idrive-docker:latest .
```
Image is tagged `idrive-docker:latest`. The image is also available on Dockerhub and GHCR. Thx to @araines, the image gets also tagged with the iDrive client version.
- `snorre0815/idrive-docker:latest`
- `ghcr.io/snorre-k/idrive-docker:latest`
- `snorre0815/idrive-docker:version`
- `ghcr.io/snorre-k/idrive-docker:version`

## Run container with docker
```shell
docker volume create idrive
docker run -d --name idrive -v idrive:/opt/IDriveForLinux/idriveIt \
           -v /path/to/backup:/source/1:ro -e TZ="Etc/UTC" \
           snorre0815/idrive-docker:latest
```
Data to be backuped should be located in `/path/to/backup`. It is mapped to `/source/1` inside the container. You can specify more mappings like this to backup different folders (e.g.: `-v /path/to/anotherbackup:/source/2`). In the IDrive backup configuration you then only have to specify `/source` as backup source.

### Optional: Run with bind mounts instead of docker volumes
```shell
USERNAME=<myUserName>                              # adapt this to your needs
CONFIG_PATH=/home/$USERNAME/docker/idrive/config   # adapt this to your needs
mkdir -p $CONFIG_PATH
touch $CONFIG_PATH/idrivecrontab.json
docker run -d --name idrive \
           -v $CONFIG_PATH/cache:/opt/IDriveForLinux/idriveIt/cache \
           -v $CONFIG_PATH/user_profile:/opt/IDriveForLinux/idriveIt/user_profile \
           -v $CONFIG_PATH/idrivecrontab.json:/opt/IDriveForLinux/idriveIt/idrivecrontab.json \
           -v /path/to/backup:/source/1:ro \
           -e TZ="Etc/UTC" \
           snorre0815/idrive-docker:latest
```

## Build (optional)  & Run with docker-compose - [docker-compose.yml](https://github.com/snorre-k/idrive-docker/blob/main/docker-compose.yml)
```shell
docker compose build idrive
docker compose up -d idrive
```

### Optional: Run with docker-compose bind mounts instead of docker volumes
Adapt the mounts in the compose file `docker-compose-mounts.yml` to your needs. Take a note of the location of the `idrivecrontab.json` file. This has to be created before the start of the container. 
```shell
touch </path/to/config>/idrivecrontab.json
docker compose --file docker-compose-mounts.yml up -d idrive
```

## Tasks after first start
You have to login to your IDrive account after first start.
```
docker exec -it idrive ./idrive --account-setting
```
Now you login and specify the basic settings. For me this worked best:
- `1) Login using IDrive credentials`
  - `Enter your IDrive username:`
  - `Enter your IDrive password:`
- `1) Create new Backup Location`
  - `Enter your Backup Location` - enter a name - do no keep empty

For more information and additional `./idrive` parameters have a look at the [IDrive documentation](https://www.idrive.com/readme).
The login and settings are stored persistent in the volume or the bind mounts.

## Backup configuration
The configuration and operation of backup and restore can be done in the IDrive GUI. Help can be found on the [IDrive FAQs](https://www.idrive.com/faq_linux#linuxWeb2) for Linux.

## Migration from IDrive version 2.x
If you had the old version 2.x (latest was 2.38) running, you have to migrate the configuration to the new 3.x version. To do this, first you have to use the new image and then run `docker exec -it idrive ./idrive --account-setting`.

__WARNING:__ Please take a note on your schedules, as they will be deleted in the next steps.
- Login
- `Linux user "root" is already having an active script setup with path "/IDriveForLinux/scripts/Idrivelib/lib/dashboard.pl".
Configuring the same user profile with current path will terminate and delete all the existing scheduled jobs. Do you want to continue (y/n)?: y`
- Backup content and definitions will keep, but you have to recreate your schedules.
- If you have set your restore location to be beneath `/IDriveForLinux` you also have to adapt this, as IDrive is now located in `/opt/IDriveForLinux`.

## Timezone
Be advised, that the containers timezone is UTC and so are the backup times and the log entries. Adapt the `TC` environment variable to your timezone to have local time in place.

