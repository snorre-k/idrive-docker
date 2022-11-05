# idrive-docker
Run IDrive Linux Client in a docker container

## Requirements
- Docker and/or docker-compose installed
- IDrive account

## Build image
```shell
docker build -t idrive-docker:latest .
```
Image is tagged `idrive-docker:latest`. The image is also available on Dockerhub and GHCR
- `snorre0815/idrive-docker:latest`
- `ghcr.io/...`

## Run container with docker
```shell
docker volume create idrive
docker run --rm -d --name idrive -v idrive:/IDriveForLinux/idriveIt idrive-docker:latest
```

## Run with docker-compose - [docker-compose.yml](docker-compose.yml)
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
