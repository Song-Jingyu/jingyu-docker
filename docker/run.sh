#!/usr/bin/env bash
USER_ID=$(id -u)
GROUP_ID=$(id -g)
PASSWD_FILE=$(mktemp) && echo $(getent passwd $USER_ID) > $PASSWD_FILE
GROUP_FILE=$(mktemp) && echo $(getent group $GROUP_ID) > $GROUP_FILE


xhost +local:
docker run -it \
    -e HOME \
    -u $USER_ID:$GROUP_ID \
    -v $PASSWD_FILE:/etc/passwd:ro \
    -v $GROUP_FILE:/etc/group:ro \
    -v /mnt/ws-frb/users/jingyuso/navigation/jingyu-docker/docker/home:$HOME \
    -v /home/jingyuso/Downloads:/tmp/Downloads \
    -v /mnt:/mnt \
    --name jingyuso_ros_noetic \
    --gpus all \
    --ipc=host \
     -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XDG_RUNTIME_DIR=/run/user/$USER_ID \
    -v /run/user/$USER_ID:/run/user/$USER_ID \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    jingyuso/ros-noetic:latest # TODO: change this image name, container name and home directory accordingly
