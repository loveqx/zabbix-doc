#!/bin/bash
#Fucation: mysql low-level discovery
#Script_name:monitor-multi-mysql.sh
#judge one or multi

one=`ps xua|grep mysqld|grep -w "port=3306"|wc -l`
if [ $one -lt 1 ];then

    socket=`ps xua|grep -w "socket"|grep -v "mysqld_safe"|awk 'BEGIN {FS="--socket="} {print $2}'|awk '{print $1}'|grep sock|head -n 1`
    mysqladmin -r ext -uzabbix -pKing+5688 -P 3306 -S $socket 2>/dev/null|grep -w "$2"|awk '{print $4}'

else

    socket=`ps xua|grep -w "socket"|grep -v "mysqld_safe"|grep -w "port=$1"|awk 'BEGIN {FS="--socket="} {print $2}'|awk '{print $1}'`
    mysqladmin -r ext -uzabbix -pKing+5688 -P $1 -S $socket 2>/dev/null|grep -w "$2"|awk '{print $4}'
fi
