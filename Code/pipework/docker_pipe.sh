#!/bin/bash

dir=/data/shell

n=`wc -l $dir/pipe | awk '{print $1}'`
#echo $n
for (( i=1;i<=$n;i++ ))
do
       dockerName=`sed -n ${i}p $dir/pipe | awk '{print $1}'`
       ip=`sed -n ${i}p $dir/pipe | awk '{print $2}'`
#       echo $dockerName
#       echo $ip
        pipework br0 ${dockerName} ${ip}/22@190.168.0.1 
	echo "${dockerName} 添加 ${ip} 成功" 
done
