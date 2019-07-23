#!/bin/bash
t_datadir=`find /usr/local/tomcat/tomcat-*/conf/ -name server.xml|awk -F "/conf/server.xml" '{print $1}'`
tomcat_no=`find /usr/local/tomcat/tomcat-*/conf/ -name server.xml|wc -l`
n_port=12345
i=1
printf '{"data":[\n'
for tomcat in $t_datadir
do
    t_service=$(echo "$tomcat"|awk -F"/" '{print $(NF)}')

    if [ "$i" != ${tomcat_no} ];then

        printf "\t\t{ \n"

        printf "\t\t\t\"{#JMX_PORT}\":\"${n_port}\",\n"

        printf "\t\t\t\"{#JAVA_NAME}\":\"${t_service}\"},\n"

    else

        printf "\t\t{ \n"

        printf "\t\t\t\"{#JMX_PORT}\":\"${n_port}\",\n"

        printf "\t\t\t\"{#JAVA_NAME}\":\"${t_service}\"}]}\n"

    fi

    let "n_port=n_port+2"

    let "i=i+1"

done
