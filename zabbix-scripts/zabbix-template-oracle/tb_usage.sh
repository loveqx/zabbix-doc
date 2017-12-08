#!/bin/bash
str=${ORACLE_HOME#*product/}
str1=${str%%.*}
if [ "$str1" == "12" ]; then

pdbs=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off timing off
select name from v\\$pdbs where open_mode='READ WRITE';
exit;
EOSQL`

for db in $pdbs ; do 

sqlplus -s '/as sysdba' <<zzz
set lines 200 pages 500
set echo off
set feedback off
alter session set container=$db;
select  db_name||' | '||tablespace_name||' | '||allocated||' | '||used||' | '||free||' | '||usage  from 
(select  database_name db_name,tablespace_name, round(allocated) allocated,round(used) used,round(allocated-used) free,round(used/allocated*100) usage from 
(select tablespace_name, sum(case autoextensible when 'YES' then maxbytes else bytes end)/1024/1024 as allocated, sum(user_bytes)/1024/1024 used from dba_data_files group by tablespace_name order  by tablespace_name));
exit;
zzz

done

else

for SID in $(ps -fu oracle | grep pmon | grep -v grep | cut -d_ -f3- | sort); do
export ORACLE_SID=$SID
sqlplus -s '/as sysdba' <<zzz
set lines 200 pages 500
set echo off
set feedback off
select  db_name||' | '||tablespace_name||' | '||allocated||' | '||used||' | '||free||' | '||usage  from 
(select  nvl(substr(database_name,1,instr(database_name,'.',1)-1),'$SID') db_name,tablespace_name, round(allocated) allocated,round(used) used,round(allocated-used) free,round(used/allocated*100) usage from 
(select tablespace_name, sum(case autoextensible when 'YES' then maxbytes else bytes end)/1024/1024 as allocated, sum(user_bytes)/1024/1024 used from dba_data_files group by tablespace_name order  by tablespace_name));
exit;
zzz
done


fi