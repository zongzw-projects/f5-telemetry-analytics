#!/bin/bash

if [ $# -ne 1 ]; then echo "$0 <filepath>"; exit 1; fi

path=$1
if [ ! -f "$path" ]; then echo "invalid file: $path"; exit 1; fi

file "$path" | grep text > /dev/null
if [ $? -ne 0 ]; then echo "$path is not a text file."; exit 1; fi

i=0
while read line; do
    # echo read: --$line--
    echo $i
    i=$(($i + 1))
    echo $line | nc localhost 20002
    # sleep 1
done < "$path"