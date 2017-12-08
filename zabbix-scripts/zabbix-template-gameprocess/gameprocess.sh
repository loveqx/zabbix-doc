#!/bin/bash
#gameprocess=(`ps xua|grep -E "\.\/server_global|\.\/server_ps|\.\/server_log|\.\/server_location|\.\/server_name|\.\/server_rank|\.\/server_db|\.\/server_gc|\.\/media|\.\/server_th|\.\/server_zone|\.\/server_gs*|\.\/server_login|\.\/jx-proxy"|grep -v sh|grep -v python|awk '{print $11}'|awk -F[/] '{print $2}'   2>/dev/null`)
cd /opt/project
gameprocess=(`ls -ld server_* jx-proxy media|awk '{print $NF}'`)

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
