#!/bin/bash
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2":"$1;}'  >ssh_failed.txt
chown -R zabbix:zabbix /etc/zabbix/externalscripts/ssh_failed.txt
ssharray=(`cat /etc/zabbix/externalscripts/ssh_failed.txt|awk -F[:] '{print $1}' 2>/dev/null`)
length2=${#ssharray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length2;i++))
do
    printf '\n\t\t{'
    printf "\"{#SSHIP}\":\"${ssharray[$i]}\"}"
    if [ $i -lt $[$length2-1] ];then
            printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"
