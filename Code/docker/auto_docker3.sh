#!/bin/bash



echo "欢迎启动docker部署工具:  
输入1. 第一次部署新项目镜像 
输入2. 更新项目镜像
输入3. 查看本机容器地址
输入4. 清理内存
输入5. 退出程序
" 

value=0
 
read -p "请做出一个选择: " value

case $value in  
  1) echo "第一次部署新项目镜像"  
    sleep 1s

    read -p "输入项目的地址: " ip
    ping -w 1 -c 2 ${ip} &>/dev/null
    if [[ $? != 0 ]];then
      echo " 地址没有被使用，可以部署新镜像"
      sleep 1s
	 
      MSF=""
      read -p "输入项目名称: " platName
      read -p "输入项目标签: " newImageTag
      read -p "项目服务服务（api OR work）: " MSF
      echo "操作平台镜像 ${platName}:${newImageTag}"
      echo "IP地址： ${ip}"
      echo "项目服务 ${MSF}"	 
	 
      #1.拉取新版本镜像
      docker pull hub.docker.thinkchanges.cn/sfc/suntek/${platName}:${newImageTag}
      echo "新镜像 ${platName}:${newImageTag} 拉取成功"
      sleep 1s

      #创建新容器
      docker run --privileged --restart=always -it -d --hostname=${platName} --name=${platName}-${newImageTag} -e WEAVE_CIDR=${ip}/24 -e MSF_TYPE=${MSF} hub.docker.thinkchanges.cn/sfc/suntek/${platName}:${newImageTag}
      echo "-------------------新项目部署完成----------------------------"	 

    else
      echo "${ip}地址被使用，请检查或使用新地址" 
      exit 22
    fi 
  ;;
    
  2) echo "更新项目镜像"  
    sleep 1s

    MSF=""

    read -p "输入项目名称: " platName

    docker ps -a | grep ${platName}

    read -p "输入项目新标签: " newImageTag
    read -p "输入项目需要替换的旧标签: " oldImageTag
    read -p "项目服务服务（api OR work）: " MSF

    echo "操作平台新镜像 ${platName}:${newImageTag}"
    echo "操作平台老镜像 ${platName}:${oldImageTag}"
    echo "项目服务 ${MSF}"
    sleep 1s

    #1.拉取新版本镜像，获取地址，删除老容器
    docker pull hub.docker.thinkchanges.cn/sfc/suntek/${platName}:${newImageTag}
    echo "新镜像 ${platName}:${newImageTag} 拉取成功"
    sleep 1s

    ip=$(docker exec ${platName}-${oldImageTag} bash -c 'echo $WEAVE_CIDR')
    echo "------------------${ip},地址已经取到，删除老容器------------------"
    sleep 1s
    docker rm -f ${platName}-${oldImageTag}


    #2.判断地址是否使用,没有使用创建新镜像
    ping -w 1 -c 2 ${ip} &>/dev/null
    if [[ $? != 0 ]];then
      echo " 地址没有被使用，可以继续更新镜像"
      sleep 1s

      #3.创建新容器
      docker run --privileged --restart=always -it -d --hostname=${platName} --name=${platName}-${newImageTag} -e WEAVE_CIDR=${ip} -e MSF_TYPE=${MSF} hub.docker.thinkchanges.cn/sfc/suntek/${platName}:${newImageTag}
      echo "-------------------创建完成，等待2s删除最老的容器和镜像----------------------------"	 
      sleep 1s
	 
      #4.删除最老的镜像
      count=$(docker images | grep ${platName} | wc -l)
      if [[ $count -ge 3 ]];then
      docker rmi `docker images | grep ${platName} | awk '{print $3}' | awk 'END {print}'`
      echo "-----------------老镜像已经删除-----------------------"
      fi
 
    else
      echo " ${ip}地址被使用，请检查或使用新地址" 
      exit 33
    fi 
    ;;

  3) echo "查看本机容器地址: "
    echo "本机weave地址 `weave ps | grep expose | awk '{print $NF}'`"
    id=`docker ps -a | grep -v weave | grep -v CONTAINER | awk '{print $1}'`
    for i in $id
    do
       containerName=`docker ps -a | grep $i | awk '{print $NF}'`
       containerIp=`weave ps | grep  $i | awk '{print $NF}'`
       
       echo "容器名称：${containerName}    地址：${containerIp}"
    done
     ;;



  4) echo "清理内存"  
    free -h
    echo "---------开始清理----------"
    echo 3 > /proc/sys/vm/drop_caches
    echo "------查看清理后内存------"
    free -h
    ;;

  5) echo "退出程序"  
    exit 44
    ;;

  *) echo "请选择正确的选择1-5"
    exit 55
    ;;
esac
