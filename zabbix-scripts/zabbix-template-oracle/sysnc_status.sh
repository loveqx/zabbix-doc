#!/bin/sh
for SID in $(ps -fu oracle | grep pmon | grep -v grep | cut -d_ -f3- | sort); do
export ORACLE_SID=$SID
row=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select count(*) from v\\$dataguard_stats where name in ('transport lag', 'apply lag') and value is not null;
exit;
EOSQL`
if [ $row -eq 2 ];
then
t_lag=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select to_number(substr(value,2,2))*1440+to_number(substr(value,5,2))*60+to_number(substr(value,8,2)) from v\\$dataguard_stats where name ='transport lag';
exit;
EOSQL`

a_lag=`sqlplus -silent '/ as sysdba' << EOSQL
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select to_number(substr(value,2,2))*1440+to_number(substr(value,5,2))*60+to_number(substr(value,8,2)) from v\\$dataguard_stats where name ='apply lag';
exit;
EOSQL`

if [ $t_lag -gt 60 ];
then
t_lag=`echo $t_lag|tr -d " "` 
echo "Problem:$SID Transport Lag $t_lag Minutes"
else 
echo "$SID Archive log transport OK"
fi
if [ $a_lag -gt 120 ];
then
a_lag=`echo $a_lag|tr -d " "`
echo "Problem:$SID Standby not Apply Logs for $a_lag Minutes"
else 
echo "$SID Archive log apply OK"
fi
else 
echo "Problem:$SID Standby  Disconnected from Primary"
fi
done

