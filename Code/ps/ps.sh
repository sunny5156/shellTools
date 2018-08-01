ps -ef|grep php-msf|grep -v grep|awk '{print $2}'
ps -ef|grep php-msf|grep -v grep|awk '{print $2}'|xargs kill -9