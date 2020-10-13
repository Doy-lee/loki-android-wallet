#!/bin/bash
docker container rm loki-android > /dev/null 2>&1

set -e
docker create --name loki-android loki-android-image

build_dir=`pwd`/build
rm -Rf $build_dir
docker cp loki-android:/opt/android/build $build_dir
docker container rm loki-android

exit 0
sudo docker kill $(docker ps -q)
sudo docker_clean_ps
sudo docker rmi $(docker images -a -q)
