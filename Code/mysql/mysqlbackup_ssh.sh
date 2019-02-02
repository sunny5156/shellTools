#!/bin/bash

# 通过ssh远程执行远程指令
# 需要先部署key认证，保证ssh只需要ip、port即可连接
# 如果需要和远程服务器交互，请参考ssh的-t、-tt参数
# 如果需要反复登录服务器执行多条指令，请使用ssh的通道重用
# 参考：http://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing
# 使用通道需要注意退出通道，如"ssh github.com -O exit"或者"ssh github.com -O stop"
#                                              --by coding my life

#分别设置ssh用户名、数据库用户名、数据库密码、导出数据
SSH_USER='xzc_ssh'
DB_USER='xzc_db'
DB_PWD='xzc_db_pwd123'
EXP_PATH=export_data/

# 执行远程命令
# $1 服务器ip
# $2 ssh端口
# $3 指令
function exec_remote_command()
{
    ssh $SSH_USER@$1 -p $2 '$3'
}

# 执行远程sql,导出数据
# $1 服务器ip
# $2 ssh端口
# $3 指令,多个sql指令如select * from user;select * from bag;也可执行，但结果将会写到同一个文件
# s4 服务器
# $5 导出文件
function export_remote_sql()
{
    echo export from $4 ...
    cmd="echo \"$3\" | mysql $4 -u$DB_USER -p$DB_PWD --default-character-set=utf8"

    ssh $SSH_USER@$1 -p $2 "$cmd" > $EXP_PATH$4_$5    #如果要导出到远程服务器，将把 > $EXP_PATH$4_$5放到cmd中
}

# $1 区服名
# $2 ip
# $3 端口
function exec_sqls()
{
    cat SQLS | while read sql ; do
    
        fc=${sql:0:1}
        if [ "#" == "$fc" ]; then    #被注释的不处理
            continue
        fi

        #sql语句中包含空格，不能再以空格来区分。最后一个空格后的是导出的文件名
        exp_file="${sql##* }"                #两个#表示正则以最大长度匹配*和一个空格(*后面的空格),截取余下的赋值给exp_file
        sql_cmd="${sql%% $exp_file}"         #两个%表示从右至左删除%%以后的内容
        
        export_remote_sql $2 $3 "$sql_cmd" $1 "$exp_file"
    done
}

# 需要在当前目录下创建服务器列表文件SERVERS,格式为"数据库名 ip ssh端口",如"xzc_game_s99 127.0.0.1 22"
# 需要在当前目录下创建sql命令列表文件SQLS,格式为"sql语句 导出的文件",如"select * from user; user.xls"
# 多个sql请注意用;分开，sql必须以;结束
# 文件名中不能包含空格，最终导出的文件为"数据库名_文件名",如"xzc_game_s99_user.xls"

mkdir -p $EXP_PATH

cat SERVERS | while read server ; do

    fc=${server:0:1}
    if [ "#" == "$fc" ]; then    #被注释的不处理
        continue
    fi

    name=`echo $server|awk '{print $1}'`
    ip=`echo $server|awk '{print $2}'`
    port=`echo $server|awk '{print $3}'`

    exec_sqls $name $ip $port
done