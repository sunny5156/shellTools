#!/bin/sh
#数据库备份
# Database info
DB_HOST="localhost"
DB_NAME="db_gogs"
DB_USER="root"
DB_PASS="a123654"

# Others vars
BCK_DIR="/data/Backup/"
DATE=`date +%F`

#mkdir dir
#mkdir $BCK_DIR$DB_NAME -m 777
#echo $BCK_DIR$DB_NAME
#if[!-d "/data/Backup/db_gogs"];then
#  mkdir $BCK_DIR$DB_NAME/ -m 777
#fi
# TODO
mysqldump --opt -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BCK_DIR/$DB_NAME-$DATE.gz
