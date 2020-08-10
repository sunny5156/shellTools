#!/bin/bash

## 创建目录
## Code
## Code/Backend   后端代码目录
## Code/Frontend  前端代码目录
## Code/Middleend 中端代码目录

## Document 文档目录

## Database 数据库文件目录

## Backup 备份目录

## Webhook 钩子程序目录

BASE_DIR=$(cd `dirname $0`; pwd)

echo $BASE_DIR

mkdir -p "$BASE_DIR/Code/Backend" "$BASE_DIR/Code/Frontend" "$BASE_DIR/Code/Middleend"  "$BASE_DIR/Document" "$BASE_DIR/Database"  "$BASE_DIR/Backup" "$BASE_DIR/Webhook" 

DIRS=("$BASE_DIR/Code/Backend" "$BASE_DIR/Code/Frontend" "$BASE_DIR/Code/Middleend"  "$BASE_DIR/Document" "$BASE_DIR/Database"  "$BASE_DIR/Backup" "$BASE_DIR/Webhook" )
for PATH in ${DIRS[@]}
do
echo ${PATH}/.gitkeep
echo '' > ${PATH}/.gitkeep
done
