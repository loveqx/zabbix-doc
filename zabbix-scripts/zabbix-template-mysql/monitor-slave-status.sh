#!/bin/bash
#Fucation: monitor mysql slave status
#Script_name:monitor-slave-status.sh
one=`ps xua|grep mysqld|grep -w "port=3306"|wc -l`

if [ $one -lt 1  ];then

    socket=`ps xua|grep -w "socket"|grep -v "mysqld_safe"|awk 'BEGIN {FS="--socket="} {print $2}'|awk '{print $1}'|grep  sock|head -n 1`
     mysql -uzabbix -pKing+5688  -P 3306 -S $socket -e "show slave status\G" 2>/dev/null|grep -w "$2"|awk '{print $2}'
else
    socket=`ps xua|grep -w "socket"|grep -v "mysqld_safe"|grep -w "port=$1"|awk 'BEGIN {FS="--socket="} {print $2}'|awk '{print $1}'`
    #socket=`ps xua|grep -w "socket"|grep $1|awk 'BEGIN {FS="--socket="} {print $2}'`
    mysql -uzabbix -pKing+5688  -P $1 -S $socket -e "show slave status\G" 2>/dev/null|grep -w "$2"|awk '{print $2}'
fi
