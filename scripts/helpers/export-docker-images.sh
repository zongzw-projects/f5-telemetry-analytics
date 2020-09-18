#!/bin/bash

set -e
homedir=`cd $(dirname $0); pwd`/../..

if [ $# -ne 1 ]; then
    echo "$0 <target folder>"
    exit 1
fi
target_folder=$1
if [ ! -d $target_folder ]; then
    echo "$target_folder not exists !"
    exit 1
fi

echo $homedir
compose_file=$homedir/conf.d/docker-compose.yml
if [ ! -f $compose_file ]; then
    echo "docker-compose.yml file not found."
    exit 1
fi

grep -E "    image: " $compose_file | while read line; do
    echo "Saving $line..."
    image_name=`echo $line | cut -d ":" -f 2`
    image_vers=`echo $line | cut -d ":" -f 3`

    replaced_image_name=`echo $image_name | tr -s '/' '_'`

    set +e
    docker images | grep $image_name | grep $image_vers
    if [ $? -ne 0 ]; then
    set -e
        echo "  ERROR: Image $image_name:$image_vers not exists!"
        continue
    fi
    docker save -o $target_folder/$replaced_image_name@$image_vers.tar $image_name:$image_vers
done

echo ""
echo "  Successfully saved all required images to '$target_folder'."
echo ""

ls -l $target_folder
