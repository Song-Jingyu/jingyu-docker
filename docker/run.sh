#!/usr/bin/env bash
USER_ID=$(id -u)
GROUP_ID=$(id -g)
PASSWD_FILE=$(mktemp) && echo $(getent passwd $USER_ID) > $PASSWD_FILE
GROUP_FILE=$(mktemp) && echo $(getent group $GROUP_ID) > $GROUP_FILE

docker run -it \
    -e HOME \
    -u $USER_ID:$GROUP_ID \
    -v $PASSWD_FILE:/etc/passwd:ro \
    -v $GROUP_FILE:/etc/group:ro \
    -v /mnt/ws-frb/users/jingyuso/kd_project/dockers/unidistill_docker/docker/home:$HOME \
    -v /mnt:/mnt \
    --name jingyuso_kd_unidistill \
    --gpus all \
    --ipc=host \
    jingyuso/kd_unidistill:latest # TODO: change this image name, container name and home directory accordingly
