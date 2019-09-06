#!/bin/sh
docker pull cscix65g/swift-runtime:arm64-latest
if [ ! "$(docker ps --all -q -f name=swift_runtime)" ]; then
    echo "Launching swift_runtime"
    if [ "$(docker volume ls | grep swift_runtime_usr_bin)" ]; then
        docker volume rm swift_runtime_usr_bin >> /dev/null
    fi
    docker volume create swift_runtime_usr_bin
    if [ "$(docker volume ls | grep swift_runtime_usr_lib)" ]; then
        docker volume rm swift_runtime_usr_lib >> /dev/null
    fi
    docker volume create swift_runtime_usr_lib
    if [ "$(docker volume ls | grep swift_runtime_lib)" ]; then
        docker volume rm swift_runtime_lib >> /dev/null
    fi
    docker volume create swift_runtime_lib
    if [ "$(docker volume ls | grep swift_debug)" ]; then
        docker volume rm swift_debug >> /dev/null
    fi
    docker volume create swift_debug
    docker run \
           --detach \
           --name swift_runtime \
           -v swift_runtime_lib:/lib \
           -v swift_runtime_usr_lib:/usr/lib \
           -v swift_runtime_usr_bin:/usr/bin \
           cscix65g/swift-runtime:arm64-latest
    docker logs swift_runtime
fi
docker stop e16server || true
docker pull 10.8.0.55:6000/cscix65g/e16server:latest
docker run \
       --privileged \
       --rm \
       --detach \
       --name e16server \
       --net=host \
       -v swift_runtime_lib:/lib \
       -v swift_runtime_usr_lib:/usr/lib \
       -v swift_runtime_usr_bin:/usr/bin \
       10.8.0.55:6000/cscix65g/e16server:latest
sleep 3
docker ps --filter name=e16server
