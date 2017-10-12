#!/bin/bash
#Fucation: mysql low-level discovery
#Script_name: mysql_port_discovery.sh
mongo() {
    port1=(`sudo /bin/netstat -tpln | awk -F "[ :]+" 'BEGIN {IGNORECASE=1; } /mongod/ && /127.0.0.1/ {print $5}'`)
    port2=(`sudo /bin/netstat -tpln | awk -F "[ :  ]+" 'BEGIN {IGNORECASE=1; } /mongod/ && /0.0.0.0/ {print $5}'`)

    if [ ! -n "${port1}"   ];then
        port=(`sudo /bin/netstat -tpln | awk -F "[ :   ]+" 'BEGIN {IGNORECASE=1; } /mongod/ && /0.0.0.0/ {print $5}'`)
    else
        port=(`sudo /bin/netstat -tpln | awk -F "[ : ]+" 'BEGIN {IGNORECASE=1; } /mongod/ && /127.0.0.1/ {print $5}'`)
    fi

    max_index=$[${#port[@]}-1]
    printf '{\n'
    printf '\t"data":['
    for key in `seq -s' ' 0 $max_index`
    do
        printf '\n\t\t{'
        printf "\"{#MONGOPORT}\":\"${port[${key}]}\"}"
        if [ $key -ne $max_index ];then
            printf ","
        fi

    done
    printf '\n\t]\n'
    printf '}\n'
}
$1
