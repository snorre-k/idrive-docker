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
Image is tagged `idrive-docker:latest`. The image is also available on Dockerhub and GHCR
- `snorre0815/idrive-docker:latest`
- `ghcr.io/snorre-k/idrive-docker:latest`

## Run container with docker
```shell
docker volume create idrive
docker run --rm -d --name idrive -v idrive:/opt/IDriveForLinux/idriveIt -v /path/to/backup:/source/1:ro -e TZ="Etc/UTC" idrive-docker:latest
```
Data to be backuped should be located in `/path/to/backup`. It is mapped to `/sources/1` inside the container. You can specify more mappings like this to backup different folders (e.g.: `-v /path/to/anotherbackup:/source/2`). In the IDrive backup configuration you then only have to specify `/source` as backup source.

## Run with docker-compose - [docker-compose.yml](https://github.com/snorre-k/idrive-docker/blob/main/docker-compose.yml)
```shell
docker-compose build idrive
docker-compose up -d idrive
```

## Tasks after first start
You have to login to your IDrive account after first start.
```
docker exec -it idrive ./idrive --account-setting
```
Now you login and specify the basic settings. For me this worked best:
- `Create new Backup Location`
- `Enter your Backup Location` - enter a name - do no keep empty
- `Do you want to login as ...: y` - otherwise you have to login again afterwords with `./drive --login` or `./drive --account-setting`

For more information and additional `./idrive` parameters have a look at the [IDrive documentation](https://www.idrive.com/readme).
The login and settings are stored persistent in the volume.

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
