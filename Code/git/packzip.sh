#!/bin/bash

if [ ! -n "$1" ] ;then
 echo "缺少参数1" 
 exit
fi

if [ ! -n "$2" ] ;then
 echo "缺少参数2" 
 exit
fi

GIT_START_NUM=$1
GIT_END_NUM=$2


#git diff ${GIT_START_NUM} ${GIT_END_NUM} --name-only | xargs zip update.zip
git archive -o update.tar.gz HEAD $(git diff ${GIT_START_NUM} ${GIT_END_NUM} --name-only)