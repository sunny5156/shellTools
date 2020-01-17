#!/bin/bash

#有线上新的云主机，可以使用该脚本完成初始化的一些配置,root下执行
#执行完需要给宿主机设置weave ip



#1.修改主机名并设置weave主机ip

weave_master="10.169.246.230"

ip=$(curl myip.ipip.net | awk '{print $2}' | sed s@IP：@@)
zone=$(curl myip.ipip.net | awk '{print $4}')

if [ $zone == "香港" ];then
   weave_master="47.107.228.156"
fi

hostnamectl set-hostname work-$(echo $ip | awk -F"." '{print $4}')




#2.创建堡垒机super用户
useradd super
echo XaSt@123654taiwei// | passwd --stdin super > /dev/null 2>&1

#加权限
cat >>/etc/sudoers<<EOF
Cmnd_Alias SU = /bin/su
super ALL = (root)  NOPASSWD: SU
super ALL=(ALL) NOPASSWD: /bin/sudo
EOF





#3.装一些工具
yum install -y htop wget unzip zip lrzsz




#4.如果有第二块磁盘，分区挂载/data
fdisk -l /dev/vdb
RETVAL=$?
if [ $RETVAL -eq 0 ];then
cat >>/root/autopart.txt<<EOF
n
p
1


w
q 
EOF

fdisk /dev/vdb < /root/autopart.txt
mkfs.ext4 /dev/vdb1
partprobe
mkdir /data
rm -f /root/autopart.txt
echo "UUID=$(blkid /dev/vdb1 | awk -F"\"" '{print $2}') /data        ext4    defaults     1 1" >> /etc/fstab
mount -a

else
  mkdir /data
fi



#5.安装docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y

#修改路径
sed -i.bak 's@ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock@ExecStart=/usr/bin/dockerd --graph /data/lib/docker@g' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

#登陆仓库
docker login -uxast -pXast123456 hub.docker.thinkchanges.cn



#6.安装weave
wget -O /usr/bin/weave https://raw.githubusercontent.com/zettio/weave/master/weave
chmod +x /usr/bin/weave
weave launch $weave_master


#设置weave变量
echo "export DOCKER_HOST=unix:///var/run/weave/weave.sock" >> /etc/profile
source /etc/profile
systemctl restart docker





#7.添加硬盘和磁盘监控
mkdir -p /data/shell

echo "*/5 * * * * curl -s --location http://xian.suntekcorps.com:8801/sunny5156/shellTools/raw/dev/Code/check/check_cpu.sh | bash -" >> /var/spool/cron/root
echo "*/5 * * * * curl -s --location http://xian.suntekcorps.com:8801/sunny5156/shellTools/raw/dev/Code/check/check_disk.sh | bash -" >> /var/spool/cron/root

systemctl restart crond
