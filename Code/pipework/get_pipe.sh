#!/bin/bash

dir=/data/shell


if [[ -f $dir/pipe ]];then
   cat /dev/null > $dir/pipe   
fi

for i in `docker ps -aq |awk '{print $1}'`
do
   docker exec -it $i bash -c "ip a" | grep 190 &> /dev/null
   RETVAR=$?
   if [ $RETVAR -eq 0 ];then
     name=`docker ps -a | grep $i | awk '{print $NF}'`
     ip=`docker exec -it $i bash -c "ip a" |grep 190 |awk '{print $2}' |awk -F"/" '{print $1}'`
  
#     echo $name
#     echo $ip
     echo $name $ip >> $dir/pipe
   else
     noip_name=`docker ps -a | grep $i | awk '{print $NF}'`
     echo -e "\033[33m $noip_name \033[0m" is not running or no 190ip !
   fi
done
