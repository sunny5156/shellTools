#!/bin/bash
redis-cli -h 172.20.0.1 -p 6379 -a password -n 0 keys "*" | while read key
do
    redis-cli -h 172.20.0.1 -p 6379 -a password -n 0 --raw dump $key | perl -pe 'chomp if eof' | redis-cli -h 172.20.0.2 -p 6379 -a password -n 1 -x restore $key 0
    echo "migrate key $key"
done