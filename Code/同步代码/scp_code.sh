#!/bin/bash

src_dir=/vue-msf/data/www/advtManager
dest_dir=/vue-msf/data/www/advtManager
user=super
newtime=$(date +%Y%m%d%H%M%S)

file_name=$1

echo A | unzip ${src_dir}/$1 -d ${dest_dir}
echo "===================156 docker 里的新代码解压覆盖完成，等待3s，重启服务======================================"
sleep 3
/vue-msf/php/bin/php /vue-msf/data/www/advtManager/Code/Backend/server.php restart
echo "===================156 docker 重启server.php完成，等待5s,重新打包新代码======================================"

cd /vue-msf/data/www/ && /usr/bin/zip -r advtManager-bak-$newtime.zip advtManager
echo "===================156 docker 里的新代码打包完成，等待5s,将完整的新代码包传给其他节点========================"

#/usr/bin/rm -f ${dest_dir}/$1
#echo "===================156 docker 里的解压包删除完成，等待5s,部署下一个节点======================================"


sleep 5

ip_list="
192.168.0.4
192.168.0.16
192.168.0.30
192.168.0.23
"
for IP in $ip_list
do
  scp /vue-msf/data/www/advtManager-bak-$newtime.zip $user@$IP:/vue-msf/data/www/
  echo "========================= $IP 分发完成,等待3s,开始解压覆盖==========================================================="
  sleep 3
  ssh $user@$IP "echo A | unzip /vue-msf/data/www/advtManager-bak-$newtime.zip -d /vue-msf/data/www/"
  echo "======================== $IP 解压完成，等待5s，部署下一个节点========================================================"
  sleep 3
#  ssh $user@$IP "/vue-msf/php/bin/php /vue-msf/data/www/advtManager/Code/Backend/server.php restart"
#  echo "======================== $IP 重启server.php，等待3s,删除解压包========================================================"
#  sleep 3
  ssh $user@$IP "cd /vue-msf/data/www && /usr/bin/rm -f advtManager-bak-$newtime.zip"
  echo "======================== $IP 删除解压包完成，等待5s,部署下一个节点========================================================"
done


echo "======================================================================================================================="
echo "==========================部署完成，您辛苦了！========================================================================="
echo "======================================================================================================================="
