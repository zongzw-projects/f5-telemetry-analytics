#!/bin/bash

set -e
if [ $# -ne 1 ]; then
    echo "$0 <image folder>"
    exit 1
fi

image_folder=$1
if [ ! -d $image_folder ]; then
    echo "$image_folder not exists !"
    exit 1
fi

HOMEDIR=`cd $(dirname $0); pwd`/../..
docker_path=$HOMEDIR/docker

set +e
which md5 > /dev/null 2>&1
set -e
md5bin=""
if [ $? -ne 0 ]; then
    md5bin=`which md5`
else
    md5bin=`which md5sum`
fi

count=0
for n in `ls $image_folder/*.tar`; do
    echo "Loading $n ..."
    docker load < $n
    count=$(($count + 1))
done

for n in `cd $docker_path; ls`; do
    dockerfile_path=$HOMEDIR/docker/$n/Dockerfile
    md5_file=$HOMEDIR/docker/.$n.image.md5
    $md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}" > $md5_file;
done


echo ""
echo "    Successfully loaded $count image(s)"
echo ""

docker images
