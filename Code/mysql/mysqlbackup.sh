#!/bin/bash

#Database info
DB_HOST="127.0.0.1"
DB_NAME="db_cxnet"
DB_USER="root"
DB_PASS="a123654"

#Other vars
BCK_DIR="/data/backup/mysql/"
DATE=`date +%F`

#mkdir dir
if [ ! -d $BCK_DIR$DB_NAME ]; then
    mkdir -p $BCK_DIR$DB_NAME -m 777
fi
mysqldump --opt -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BCK_DIR$DB_NAME/$DB_NAME-$DATE.gz

