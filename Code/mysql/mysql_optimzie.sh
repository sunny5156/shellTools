#!/bin/bash
host_name=ip
user_name=username
user_pwd=password
database=db_name
need_optmize_table=true
tables=$(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "show tables")
for table_name in $tables
do
check_result=$(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "check table $table_name" | awk '{ print $4 }')
if [ "$check_result" = "OK" ]
then
echo "It's no need to repair table $table_name"
else
echo $(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "repair table $table_name")
fi
# 优化表,可提高性能
if [ $need_optmize_table = true ]
then
echo $(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "optimize table $table_name")
fi
done