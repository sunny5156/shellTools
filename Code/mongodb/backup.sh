#!/bin/bash
DUMP=/usr/bin/mongodump   #mongodump命令路径

OUT_DIR=/data/backup/mongodb_bak    #临时备份目录 

TAR_DIR=/data/backup/mongodb_bak_list    #备份存放路径

if [ !-d $TAR_DIR ]; then
	mkdir -p $TAR_DIR
fi 

DATE=`date +%Y_%m_%d`   #获取当前系统时间 

DB_USER=admin    #数据库账号 

DB_PASS=123456    #数据库密码



DAYS=20    #DAYS=20代表删除20天前的备份，即只保留近20天的备份


TAR_BAK="mongodb_bak_$DATE.tar.gz"    #最终保存的数据库备份文件 

cd $OUT_DIR

rm -rf $OUT_DIR/*
mkdir -p $OUT_DIR/$DATE
  
#$DUMP -h 127.0.0.1:27017 -u $DB_USER -p $DB_PASS --authenticationDatabase "admin" -o $OUT_DIR/$DATE   #备份全部数据库
$DUMP -h 127.0.0.1:27017 -o $OUT_DIR/$DATE   #备份全部数据库

tar -zcvf $TAR_DIR/$TAR_BAK $OUT_DIR/$DATE    #压缩为.tar.gz格式

find $TAR_DIR/ -mtime +$DAYS -delete   #删除20天前的备份文件

exit