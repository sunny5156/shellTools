#!/bin/bash

platName=$1
newImageTag=$2
oldImageTag=$3

echo "操作平台新镜像 ${platName}-advt:${newImageTag}"
echo "操作平台老镜像 ${platName}-advt:${oldImageTag}"
sleep 3


#1.创建新版本镜像
docker pull hub.docker.thinkchanges.cn/sfc/suntek/${platName}-advt:${newImageTag}
docker run --privileged --restart=always -it -d --hostname=${platName}-advt --name=${platName}-advt-${newImageTag}  hub.docker.thinkchanges.cn/sfc/suntek/${platName}-advt:${newImageTag}
echo "-------------------${platName}-advt:${newImageTag}拉取创建成功---------------------------------------------------------------------------------"


#2.更换新版本镜像
ip=$(weave ps |grep `docker ps -a | grep ${oldImageTag} | awk '{print $1}'` | awk '{print $NF}' | awk -F'/' '{print $1}')

weave detach ${ip}/24 ${platName}-advt-${oldImageTag}
echo "-------------------${ip}已经取下，等待付于新镜像-----------------------------------------------------------------------------------------------"
sleep 3

docker stop ${platName}-advt-${oldImageTag}
echo "-------------------${platName}-advt-${oldImageTag}镜像已经停止，等待50s付于地址${ip}-----------------------------------------------------------"
sleep 50

weave attach ${ip}/24 ${platName}-advt-${newImageTag}
echo "-------------------${ip}添加完成，等待3s删除最老的容器和镜像-----------------------------------------------------------------------------------"
sleep 3


#3.删除最老的镜像
count=$(docker ps -a | awk '{print $NF}' | grep ${platName}-advt | wc -l)
if [[ $count -ge 3 ]];then
  oldName=`docker ps -a | awk '{print $NF}' | grep ${platName}-advt | awk 'END {print}'`
  echo ${oldName}

  oldTag=$(docker ps -a | awk '{print $NF}' | grep ${platName}-advt | awk 'END {print}' | awk -F'-' '{print $3}')
  echo ${oldTag}

  docker rm -f ${oldName}
  echo "-----------------${oldName}容器已经删除-------------------------------------------------------------------------------------------------------"

  docker rmi `docker images | grep ${oldTag} | awk '{print $3}'`
  echo "-----------------${oldName}镜像已经删除-------------------------------------------------------------------------------------------------------"
fi
