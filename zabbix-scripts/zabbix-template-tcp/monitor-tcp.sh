#!/bin/bash

established () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'ESTAB' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
listen () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'LISTEN' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
timewait () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'TIME-WAIT' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
timeclose () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'CLOSED' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
finwait1 () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'FIN-WAIT1' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}

finwait2 () {
       VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'FIN-WAIT2' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}

synsent () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'SYS-SENT' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
synrecv () {
        VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'SYS-RECV' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}
closewait () {
       VALUE=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'CLOSE-WAIT' | awk '{print $2}')
        [ "${VALUE}" != "" ] && echo ${VALUE}|| echo 0
}

# Run the requested function
case "$1" in
established)
established
;;
listen)
listen
;;
timewait)
timewait
;;
timeclose)
timeclose
;;
finwait1)
finwait1
;;
finwait2)
finwait2
;;
synsent)
synsent
;;
synrecv)
synrecv
;;
closewait)
closewait
;;
*)
 echo "Usage: $0 { established|listen|timewait|timeclose|finwait1|finwait2|synsent|synrecv|closewait}"
;;
esac
