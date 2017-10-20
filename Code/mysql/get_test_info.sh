#!/bin/bash
INTERAVL=5 //运行间隔 多长时间手机一次信息
PREFIX=/data/mysqltest/benchmarks/$INTERVAL -sec-status
RUNFILE=/data/mysqltest/benchmarks/running
echo "1" >　$RUNFILE
MYSQL=/usr/local/mysql/bin/mysql
$MYSQL -e "show global variables" >> mysql-variables
while test -e $RUNFILE;do
		file=$(date +%F_%I)
		sleep=$(date +%s.%N | awk '{print 5 - ($1 % 5)}')
		sleep $sleep
		ts="$(date +"TS %s.%N %F %T")"
		loadavg="$(uptime)"
		echo "$ts $loadavg" >> $PREFIX
