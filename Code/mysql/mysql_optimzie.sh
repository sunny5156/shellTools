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
msg="It's no need to repair table $table_name"

echo -e "\033[32m ${msg} \033[0m \n"
else
msg=$(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "repair table $table_name")
echo -e "\033[31m ${msg} \033[0m \n"
fi
# 优化表,可提高性能
if [ $need_optmize_table = true ]
then
msg=$(mysql -h$host_name -u$user_name -p$user_pwd $database -A -Bse "optimize table $table_name")
echo -e "\033[36m ${msg} \033[0m \n"
fi
done