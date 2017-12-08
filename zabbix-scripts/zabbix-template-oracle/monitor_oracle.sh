#!/bin/bash
gameprocess=(`su - oracle -c /etc/zabbix/externalscripts/tbs_usage.sh|grep -v "-"|grep -v ".*NAME"|grep -v "^$"|grep -v "rows"|awk -F ["|"] '{print $1,"-",$2}'|sed 's/[ \t]*//g' 2>/dev/null`)
#gameprocess=(`su - oracle -c /etc/zabbix/externalscripts/tbs_usage.sh|grep -v "-"|grep -v ".*NAME"|grep -v "^$"|grep -v "rows"|awk -F ["|"] '{print $1}' 2>/dev/null`)
length1=${#gameprocess[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length1;i++))
do
        printf '\n\t\t{'
        printf "\"{#GAMEPROCESS}\":\"${gameprocess[$i]}\"}"
        if [ $i -lt $[$length1-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
EOF