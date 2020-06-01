#!/bin/bash 

cdir=`cd $(dirname $0);pwd`
export HOMEDIR=$cdir/..

# TODO: since we have multiple fluentd conf files,
#   the following settings become out of time.
export ES_INDEX=general
export FLUENTD_PORT=20001
export FLUENTD_PROTOCAL=udp

docker-compose -f $HOMEDIR/conf.d/docker-compose.yml down

