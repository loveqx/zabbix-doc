#!/bin/bash
diskarray=(`cat /proc/diskstats |grep -E "\bvd[a-z]\b|\bhd[a-z]\b|\bsd[a-z]\b|\bc0d0p[0-9]\b"|grep -i "\b$1\b"|awk '{print $3}'|sort|uniq   2>/dev/null`)
length2=${#diskarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length2;i++))
do
    printf '\n\t\t{'
    printf "\"{#DISK}\":\"${diskarray[$i]}\"}"
    if [ $i -lt $[$length2-1] ];then
            printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"
