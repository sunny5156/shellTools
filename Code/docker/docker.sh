#!/bin/bash
arr_img=(`docker ps -a | grep hub.docker | awk '{print $2}'`)
arr_ip=(`docker ps -a | grep hub.docker | awk '{print $1}' | xargs -i docker inspect {} | grep WEAVE_CIDR | cut -d '=' -f 2 |cut -d '"' -f 1 |cut -d '/' -f 1`)
arr_type=(`docker ps -a | grep hub.docker | awk '{print $1}' | xargs -i docker inspect {} | grep MSF_TYPE | cut -d '=' -f 2 |cut -d '"' -f 1`)
arr_name=(`docker ps -a | grep hub.docker | awk '{print $16}'`)
arr_hostname=(`docker ps -a | grep hub.docker | awk '{print $1}' | xargs -i docker inspect {} | grep Hostname | grep -v HostnamePath | cut -d ':' -f 2 | cut -d '"' -f 2`)
echo ${arr_img[1]}


length=${#arr_img[@]}

echo $length

for((i=0;i<$length;i++));  
do   
#echo $i;  
echo "docker run --privileged --restart=always -it -d --hostname="${arr_hostname[$i]}" --name="${arr_name[$i]}" -e WEAVE_CIDR="${arr_ip[$i]}"/22 -e MSF_TYPE="${arr_type[$i]} ${arr_img[$i]}

done
