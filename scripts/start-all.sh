#!/bin/bash

cdir=`cd $(dirname $0); pwd`;
export HOMEDIR=$cdir/..
export ES_INDEX=general
export FLUENTD_PORT=20001
export FLUENTD_PROTOCAL=udp

function refresh_image_if_necessary() {
    
    md5bin=`which md5`
    if [ x"$md5bin" = x ]; then md5bin=`which md5sum`; fi; 

    for n in fluentd ctrlbox; do 
        echo "Generating image: $n ..."

        dockerfile_path=$HOMEDIR/docker/$n/Dockerfile
        md5_file=$HOMEDIR/docker/.$n.image.md5
        curmd5=`$md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}"`
        image_name=f5networks/$n:latest
        image_found=`docker images --format "{{.Repository}}:{{.Tag}}" | grep $image_name`

        if [ ! -f $md5_file \
            -o "`cat $md5_file`" != "$curmd5" \
            -o x"$image_found" = x ]; then
            docker build -t $image_name $(dirname $dockerfile_path);
            $md5bin $dockerfile_path | grep -oE "[0-9a-z]{32}" > $md5_file;
        fi
    done
    
}

refresh_image_if_necessary

chmod -R 777 $HOMEDIR/data/* # permission denied in linux.
rm -rf $HOMEDIR/data/kafka/* # remove legacy kafka data for no persistence.

# ERROR: [1] bootstrap checks failed
# [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

if [ $? -eq 0 ]; then sysctl -w vm.max_map_count=262144; fi # ?: the state of last cmd quit, 0 is right, 1 is error

# docker-compose -f $HOMEDIR/conf.d/docker-compose.yml $demo_yml_option down # force remove and recreate the network
docker-compose -f $HOMEDIR/conf.d/docker-compose.yml up -d --force-recreate --remove-orphans

sleep 1
for n in "CTRLBOX" "FLUENTD"; do 
    docker ps | grep "$n" > /dev/null
    if [ $? -ne 0 ]; then echo "$n not found, cannot forward, quit."; exit 1; fi
done

docker exec CTRLBOX "/root/workdir/scripts/cmds-in-ctrlbox/setup-efk.sh"

# x='
# 0. start docker containers..
# 1. kibana:          import kibana settings
# 2. elasticsearch:   create index mapping

# 3. edit .setup.rc.
# (. bigip:           create a fake virtual server on bigip)

# 4. bigip:           create logging irule
# 5. bigip:           setup bigip virtual server irule

# 6. ctrlbox          run python http-test.py
# '
