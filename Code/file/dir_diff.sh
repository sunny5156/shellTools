#!/bin/bash
# @file         for_diff.sh
# @author       ymm
# @brief        比较不同目录下指定文件目录的差异
# @date         2014/2/28 16:18:10
# @History
# 1、2014/2/28 16:18:10  author ymm    初步完成
 
 
path_src="/c/Users/Administrator/Desktop/shopee/app/Console/Shopee"
path_desc="/c/Users/Administrator/Desktop/app.bak-201810261514/app/Console/Shopee"
 
 
#只比较备份文件中的.cpp .h 和makefile文件，如需比较其他文件，可以指定
files=$(ls $path_src/*)
#files=$(ls $path_src/*)
 
 
for file in $files
do
    filename=$(basename $file )
    file_desc=${path_desc}/${filename}
    
    diff ${file} ${file_desc} 1>/dev/null 2>&1 && result=0 || result=1
 
 
    if [ "$result" == 1 ];then
        echo "$filename is diff"
    fi
done