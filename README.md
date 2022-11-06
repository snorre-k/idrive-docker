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
docker run --rm -d --name idrive -v idrive:/IDriveForLinux/idriveIt -v /path/to/backup:/source/1:ro idrive-docker:latest
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
docker exec -it idrive bash
./account_setting.pl
```
Now you login and specify the basic settings. For me this worked best:
- `Create new Backup Location`
- `Enter your Backup Location` - enter a name - do no keep empty
- `Do you want to login as ...: y` - otherwise you have to login again afterwords with `./login.pl` or `./account_setting.pl`

For more information have a look at the [IDrive documentation](https://www.idrive.com/readme).
The login and settings are stored persistent in the volume.

## Backup configuration
The configuration and operation of backup and restore can be done in the IDrive GUI. Help can be found on the [IDrive FAQs](https://www.idrive.com/faq_linux#linuxWeb2) for Linux.

Be advised, that the containers timezone is UTC and so are the backup times and the log entries. Maybe this will be altered and made configurable in a furure change.
