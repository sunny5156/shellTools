#! /bin/sh
#清理内存
freemem=$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')
if [ $freemem -le 3028200 ]
then
date >> /var/log/mem.log
free -m >> /var/log/mem.log
sync
sync
echo 3 > /proc/sys/vm/drop_caches
free -m >> /var/log/mem.log
fi
