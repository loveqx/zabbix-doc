#!/bin/bash
rtxuser=$1
title=$2
msg=$3
wget -O /dev/null "https://spiapi.com:8082/api/sendmessage?recevice=$rtxuser&title=$title&message=$msg&sendtype=rtx" --no-check-certificat
