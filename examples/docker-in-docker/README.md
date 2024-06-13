# Docker in Docker

## Build

```bash
docker build -t terraform-packager .
```

## Run

```bash
DOCKER_SOCKET="/var/run/docker.sock"
DOCKER_SOCKET_GROUP=$(stat -c '%g' ${DOCKER_SOCKET?})

docker run \
  --volume ${DOCKER_SOCKET?}:${DOCKER_SOCKET?} \
  --group-add ${DOCKER_SOCKET_GROUP?} \
  terraform-packager
```
