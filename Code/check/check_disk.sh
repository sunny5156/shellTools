#!/bin/bash

disk=$(df -h | grep data$ | awk '{print $5}' | sed 's/%//g')

if [ $(echo "$disk > 80"|bc) = 1 ]; then
    curl "http://robot.cxiangnet.cn/robot.php?message=${HOSTNAME}磁盘大于${disk}%请查看&phone=18840382350"
fi
