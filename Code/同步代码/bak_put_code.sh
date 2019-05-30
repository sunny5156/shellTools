#!/bin/bash

#备份156docker里的advtManger老代码
time=$(date +%Y%m%d%H%M%S)
sshpass -p 123456 ssh super@172.17.0.2 "/usr/bin/zip -r /vue-msf/data/www/advtManager-bak-$time.zip /vue-msf/data/www/advtManager"


echo "===================156 docker里的advtManger备份完成,等待5s，上传新代码到docker里的advtManger下======================================";


sleep 5

#将本机代码传到156 docker上
sshpass -p 123456 scp $1 super@172.17.0.2:/vue-msf/data/www/advtManager


echo "===================$1新代码已经放到156 docker advtManger下,等待5s，分发到140,19,155,16 docker  advtManger下面===========================";

sleep 5

#把代码传到140，19，155，16上的advtManager下
sshpass -p 123456 ssh super@172.17.0.2 "/usr/bin/sh /home/super/scp_code.sh $1"

#echo "===========================$1新代码已经成功放到140,19,155,16 docker  advtManger下面了====================================================";
