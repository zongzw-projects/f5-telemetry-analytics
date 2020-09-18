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

count=0
for n in `ls $image_folder/*.tar`; do
    echo "Loading $n ..."
    docker load < $n
    count=$(($count + 1))
done

echo ""
echo "    Successfully loaded $count image(s)"
echo ""

docker images
