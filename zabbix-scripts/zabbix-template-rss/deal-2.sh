#!/bin/bash
result=`cat /etc/zabbix/externalscripts/zs-29-08.txt|grep -E "batch_id|task_group|host|task_idcnt|result_fail_cnt"`

if [ ! -n "$result" ]; then
  echo "null"
else
  echo $result
fi
