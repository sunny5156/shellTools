#!/bin/bash

rabbitMQuser=
rabbitMQpassword=
rabbitMQaddress=
rabbitMQport=


alias supervisorctl='supervisorctl -c /vue-msf/supervisor/supervisord.conf'

declare -A queues
queues[1]='shopee.advt.product'
queues[2]='shopee.delete.platform.advt'
queues[3]='shopee.istore.product'
queues[4]='shopee.main.product'
queues[5]='shopee.platform.advt'
queues[6]='shopee.sync.product.description'
queues[7]='shopee.sync.product.images'
queues[8]='shopee.sync.product.name'
queues[9]='shopee.sync.product.price'
queues[10]='shopee.sync.product.stock'


declare -A queueTask
queueTask['shopee.delete.platform.advt']='shopee-DeletePlatformAdvt'
queueTask['shopee.main.product']='shopee-GenerateAdvtProduct'
queueTask['shopee.istore.product']='shopee-GenerateMainProduct'
queueTask['shopee.advt.product']='shopee-PushAdvtToPlatform'
queueTask['shopee.sync.product.description']='shopee-SetProductDescription'
queueTask['shopee.sync.product.images']='shopee-SetProductImages'
queueTask['shopee.sync.product.name']='shopee-SetProductName'
queueTask['shopee.sync.product.price']='shopee-SetProductPrice'
queueTask['shopee.sync.product.stock']='shopee-SetProductStock'
queueTask['shopee.platform.advt']='shopee-SyncPlatformAdvt'

for QUEUE in ${queues[@]};
do 
    #统计每个消息队列的数量
    nums=0
    json=$(curl -s -u ${rabbitMQuser}:${rabbitMQpassword} "http://${rabbitMQaddress}:${rabbitMQport}/api/queues/advtManager/$QUEUE")
    nums=$(echo $json | jsawk 'return this.messages')
    if [ ! $nums ]; then
	nums=0
    fi
    task=`echo ${queueTask[$QUEUE]}`
    op_status=''
    echo '任务:',$task,'-',$QUEUE,'队列中存在',$nums,'个消息数据'
    if [ $nums -eq 0 ]; then
	op_status='stop'	
    else
	op_status='restart'
    fi
    echo  $task,$nums,$op_status
    supervisorctl $op_status `supervisorctl status |grep ^$task | grep -v grep | awk '{print $1}'`
done

#curl "http://robot.cxiangnet.cn/robot.php?message=rabbit重启成功&phone=17702903120"
