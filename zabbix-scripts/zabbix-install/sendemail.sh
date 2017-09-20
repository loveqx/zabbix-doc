#!/bin/bash

to=$1
subject=$2
body=$3

#cat <<EOF |mail -s "$subject" "$to"
#$body
#EOF

export LANG=zh_CN.UTF-8

FILE=/tmp/mailtmp.txt
echo "$3" >$FILE
dos2unix -k $FILE
/bin/mail -s "$2" $1 <$FILE


#cat <<EOF |mail -s "$subject" "$to"
#$body
#EOF

