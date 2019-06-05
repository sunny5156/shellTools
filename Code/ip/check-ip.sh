#!/bin/bash
star=`date +%s`
echo "*********Running...**********"
for ((i = 0; i <= 255; i++))
do
{
    ping 190.168.3.$i -c 2 |grep -q "ttl=" && echo "190.168.3.$i yes" >> ipyes.txt || echo "190.168.3.$i no" >> ipno.txt
}&
done
wait

end=`date +%s`
echo $end
echo "*************Spent Time:`expr $end - $star `**************"
