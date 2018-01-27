#!/usr/bash

#date1=`date  --date='2 days ago' "+%Y-%m-%d" `
date1=`date -d yesterday "+%Y-%m-%d"`
#date1=`date  "+%Y-%m-%d"`

mysql -uzabbix -pzabbix  -e "use tasklog;select
        system,batch_id,task_group,host,count(distinct task_id) task_idcnt, sum(case 
            when exec_result  = 0 then 1 
            else 0 
        end) result_success_cnt, sum(case 
            when exec_result != 0 then 1 
            else 0 
        end)  result_fail_cnt, avg(exec_cost_time) avg_exec_cost_time, sum(exec_cost_time) sum_exec_cost_time,  avg(used_retry_times) avg_used_retry_times, sum(used_retry_times) sum_used_retry_times, avg(exec_result_size)  avg_exec_result_size, sum(exec_result_size) sum_exec_result_size, sum(exec_count) sum_exec_count,  (sum(exec_count) * 1000 / sum(exec_cost_time)) tps, sum(case 
            when task_status = 'INIT' then  1 
            else 0 
        end) status_init_cnt, sum(case 
            when task_status = 'RUNNING' then 1 
            else 0 
        end) status_running_cnt,  sum(case 
            when task_status = 'RETRY' then 1 
            else 0 
        end) status_retry_cnt, sum(case 
            when task_status  = 'END' then 1 
            else 0 
        end) status_end_cnt 
    from
        tasklog 
    where
        task_date = '$date1' 
              and batch_id='TZ_GMT$1'
                                and host='$2'
                                and task_group in ('dw','ad', 'st_high', 'st_low','fig','mycat_high')
    group by
        system,batch_id,task_group,host\G"
