#!/bin/bash
FAIL_SERVICE=`supervisorctl status | awk '$2=="FATAL" || $2=="STOPPED" {print $1}'`

NUM=`echo  $FAIL_SERVICE | wc -L`

echo $NUM 

if [ $NUM != 0 ]; then 
	supervisorctl start $(supervisorctl status | awk '$2=="FATAL" || $2=="STOPPED" {print $1}')
else
	echo "service is OK!"
fi

