#!/bin/bash

cdir=`cd $(dirname $0); pwd`
workdir=$cdir/../..

host_endpoint="http://elasticsearch:9200"

index_template_home=$workdir/conf.d/elasticsearch/index-tmeplate

echo -n "Setting read_only_allow_delete to false ... "
curl -X PUT -s -w "%{http_code}" -H "Content-Type: application/json" $host_endpoint/_settings \
  -d '{ "index": { "blocks": { "read_only_allow_delete": "false" } } }'
echo

# number_of_shards: 分片给不同 es 节点，等于 es 节点数
(
  cd $index_home
  timestr=`get_n_hour_further_datestr $future_n`
  for n in `ls`; do 
    response=`curl -s -o /dev/null $host_endpoint/_template/$n -w "%{http_code}"`
    if [ "$response" != "200" ]; then
      echo -n "Creating index-template: $n ... "
      curl -X PUT -s -w "%{http_code}" \
        -H "Content-Type: application/json" \
        $host_endpoint/_template/$n -d@$n
      echo
    fi
  done
)

