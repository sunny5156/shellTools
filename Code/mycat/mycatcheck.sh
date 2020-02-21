#!/bin/bash

ip=
user=
password=
port=
tel=


MYCAT_PING=`/usr/bin/mysqladmin -h${ip} -u${user} -p${password} -P${port} ping`
MYCAT_OK="mysqld is alive"

if [ "$MYCAT_PING" != "$MYCAT_OK" ]
    then
        echo "mycat not ok"
        curl "http://robot.cxiangnet.cn/robot.php?message=Mycat service failed,Wait for 5s to restart automatically&phone=${tel}" 
        
        sleep 5
        /usr/bin/ps -ef | grep mycat |grep -v grep |awk '{print $2}' |xargs kill -9 
           
        /usr/bin/sh /data/mycat/bin/mycat start
        /usr/bin/sh /usr/local/zookeeper-3.4.6/bin/zkServer.sh start
        /usr/bin/sh /data/mycat-eye/start_mycateye-agent.sh
        /usr/bin/sh /data/mycat-eye/start_mycateye-web.sh
        /usr/bin/sh /data/mycat-web/start.sh 
   
        sleep 3
        curl "http://robot.cxiangnet.cn/robot.php?message=Mycat service restarted successfully!&phone=${tel}"      
    else
        echo "mycat is ok" 
fi
