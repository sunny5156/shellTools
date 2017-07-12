#!/bin/bash
#DIR = $1
#if [ !$DIR ];then
#        echo "$DIR dir"
#fi

#for file in data
#do
#    if test -f $file
#    then
#        echo $file 是文件
#    fi
#    if test -d $file
#    then
#        echo $file 是目录
#    fi
#done

getdir()
{
echo $1
for file in $1/*
do
   if test -f $file
    then
        echo $file
        arr=(${arr[*]} $file)
    else
        getdir $file
    fi
done
}
getdir data
##echo ${arr[@]}
#
for v in ${arr[@]}
do
    echo ${v}
    if test -f $v
		then
			#echo $file 是文件
		    echo /data/bpcs_uploader/bpcs_uploader.php upload $v /cubietruck_server_01/$v
		    $(php /data/bpcs_uploader/bpcs_uploader.php upload $v /cubietruck_server_01/$v)
	fi
done
