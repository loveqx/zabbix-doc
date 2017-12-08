#!/bin/bash
#. /home/oracle/.bash_profile
frq=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off timing off
select case when (mod(trunc(max(end_time))-trunc(min(end_time)),7)=0) then 'W' when (mod(trunc(max(end_time))-trunc(min(end_time)),7)>0) then 'D' end  from v\\$rman_status where object_type like 'DB%' and end_time>sysdate-8;
exit;
EOSQL`
frq=${frq: -1}

if [ "$frq" == "D" ]; then
db_bk=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off timing off
select count(*) from v\\$rman_status where object_type like  'DB%' and status='COMPLETED' and trunc(end_time)=trunc(sysdate);
exit;
EOSQL`

elif [ "$frq" == "W" ]; then
db_bk=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off timing off
select count(*) from v\\$rman_status where object_type like 'DB%' and status='COMPLETED' and end_time>sysdate-7;
exit;
EOSQL`
fi
db_bk=${db_bk: -1}

if [ $db_bk -gt 0 ]; then
echo "DB Backup OK"
else 
echo "DB Backup Problem"
fi
