#!/bin/bash
#Fucation: mysql low-level discovery
#Script_name: monitor-mysql.sh
mysql() {
    port1=(`sudo /bin/netstat -tpln | awk -F "[ : ]+" 'BEGIN {IGNORECASE=1; } /mysql/ && /0.0.0.0/ {print $5}'`)
    port2=(`sudo /bin/netstat -tpln | awk -F "[ : ]+" 'BEGIN {IGNORECASE=1; } /mysql/ {print $4}'`)
    if [ ! -n "${port1}"  ];then
         port=$port2
    else
         port=$port1
    fi
    max_index=$[${#port[@]}-1]
    printf '{\n'
    printf '\t"data":['
    for key in `seq -s' ' 0 $max_index`
    do
        printf '\n\t\t{'
        printf "\"{#MYSQLPORT}\":\"${port[${key}]}\"}"
        if [ $key -ne $max_index ];then
            printf ","
        fi
    done
    printf '\n\t]\n'
    printf '}\n'
}
$1
