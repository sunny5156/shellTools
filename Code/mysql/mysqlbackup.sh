#!/bin/bash

if [ ! -n "$1" ] ;then
 echo "缺少参数" 
 exit
fi

#Database info
DB_HOST="localhost"
DB_NAME="$1"
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

#upload baidu yun
#php /data/bpcs_uploader/bpcs_uploader.php upload $BCK_DIR$DB_NAME/$DB_NAME-$DATE.gz /114-115-147-238/$BCK_DIR$DB_NAME/$DB_NAME-$DATE.gz