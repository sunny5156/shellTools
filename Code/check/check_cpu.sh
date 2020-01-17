#!/bin/bash

SHELL_DIR=/data/shell


vmstat 20 3 > ${SHELL_DIR}/top.log

cpu1=$(cat ${SHELL_DIR}/top.log |awk 'NR==3{print $15}')
cpu2=$(cat ${SHELL_DIR}/top.log |awk 'NR==4{print $15}')
cpu3=$(cat ${SHELL_DIR}/top.log |awk 'NR==5{print $15}')


cpu_ave_id=$(echo "($cpu1+$cpu2+$cpu3)/3" | bc)
cpu=$(echo "100-$cpu_ave_id" | bc)

#echo $cpu
if [ $(echo "$cpu > 90"| bc) = 1 ]; then
    curl "http://robot.cxiangnet.cn/robot.php?message=${HOSTNAME}CPU大于${cpu}%请查看&phone=18840382350"
fi
