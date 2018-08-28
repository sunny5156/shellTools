#!/bin/bash
source /etc/profile

# Title:    Online Query Mysql Connection
# Author:   ouyangyewei
#
# Create:   ouyangyewei, 2017/01/18
# Update:   ouyangyewei, 2017/01/19, add total_connection_number

FID=`readlink -f $0 | md5sum | awk '{print $1}'`
LOG_FILE=/home/disk5/logs/mysql_connection_$(date +"%Y-%m-%d").log
# ----------------------------------------------

function get_process_list() {
  mysql -uroot \
  -pxxx \
  -hxxx \
  -P3306 \
  -e 'show processlist' \
  --silent \
  --skip-column-names | awk '
    {
      if ($3=="user" && $4!="NULL") {
        split($4, machine, ":");
        print machine[1];
      }
      if ($3!="user" && $4!="user"){
        split($3, machine, ":");
        print machine[1];
      }
    }' | sort | uniq -c > /tmp/$FID
}

function run() {
  # get current mysql connection status
  get_process_list;

  TIMESTAMP=`date +"%F %T"`
  if [[ -f /tmp/$FID ]]; then
    sum=0
    while read line
    do
      machine=`echo $line | awk '{print $2}'`
      connect_number=`echo $line | awk '{print $1}'`
      sum=$(($sum+$connect_number))
      echo "$TIMESTAMP $machine=$connect_number" >> $LOG_FILE
    done < /tmp/$FID
    echo "$TIMESTAMP total_connection_number=$sum" >> $LOG_FILE
    echo "---------------------------------------" >> $LOG_FILE

    # remove tmp file
    rm -rf /tmp/$FID
  fi
}
# ----------------------------------------------

# starup
run