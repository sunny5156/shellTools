#!/bin/bash
if [ ! -n "$1" ] ;then
 echo "task" 
 exit
fi

if [ ! -n "$2" ] ;then
 echo "status" 
 exit
fi

supervisorctl $2 `supervisorctl status |grep ^$1 | grep -v grep | awk '{print $1}'`

