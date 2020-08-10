#!/bin/bash
PARA=$1

arr=(`echo $PARA | tr '-' ' '`) 
result=''
for var in ${arr[@]}
do
     firstLetter=`echo ${var:0:1} | awk '{print toupper($0)}'`
     otherLetter=${var:1}
     result=$result$firstLetter$otherLetter
done
#大驼峰
echo $result  
#小驼峰
firstResult=$(echo ${result:0:1} | tr '[A-Z]' '[a-z]')
result=$firstResult${result:1}
echo $result