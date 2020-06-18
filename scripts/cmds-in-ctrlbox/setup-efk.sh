#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

timeout=150
logpath=$workdir/logs/startup-`date +%Y.%m.%d.%H.%M.%S`.log

echo -n "Waiting for kibana to be ready ..."
wait=0
while true; do 
    if [ $wait -ge $timeout ]; then 
        echo "timeout for waiting for kibana readiness."
        exit 1
    fi
    res_code=`curl http://kibana:5601/app/kibana -s -o /dev/null -w "%{http_code}"`
    if [ "$res_code" = "200" ]; then 
        echo " OK"
        break; 
    else 
        echo -n "."
    fi

    wait=$(($wait + 1))
    sleep 1
done

$cdir/import-kibana-settings.sh

# logstash's startup is slow, 
# need to wait for its readiness before we can say 'system is ready'.
echo -n "Waiting for logstash to be ready ..."
wait=0
while true; do 
    if [ $wait -ge $timeout ]; then 
        echo "timeout for waiting for logstash readiness."
        exit 1
    fi
    res_code=`curl http://logstash:9600/ -s -o /dev/null -w "%{http_code}"`
    if [ "$res_code" = "200" ]; then 
        echo " OK"
        break; 
    else 
        echo -n "."
    fi

    wait=$(($wait + 1))
    sleep 1
done
