#!/bin/bash
#. /home/oracle/.bash_profile
arc_bk=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select count(*) from v\\$rman_status where object_type='ARCHIVELOG' and status='COMPLETED' and trunc(end_time)=trunc(sysdate);
exit;
EOSQL`

arc_bk=${arc_bk#*.}

if [ $arc_bk -gt 0 ]; then
echo "Archivelog Backup OK"
else
echo "Archivelog Backup Problem"
fi

