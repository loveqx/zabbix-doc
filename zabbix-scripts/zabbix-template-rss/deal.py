#!/usr/bin/env python

import commands
import json


def get_result(mylist,myname):
    try:
        ad_index = mylist.index(myname)
    except:
        _rt_dic[myname] = (0,0)
    else:
        ad_task_idcnt = int(mylist[mylist.index(myname)+4])
        ad_result_fail_cnt = int(mylist[mylist.index(myname)+6])
        _rt_dic[myname] = (ad_task_idcnt,ad_result_fail_cnt)
    return _rt_dic

_rt_dic = {}
_rt_list =[]
_s,_rt = commands.getstatusoutput('sh /etc/zabbix/externalscripts/deal-2.sh')
if _rt=='null':
    print 'null'
else:
    rt = _rt.split()
    for name in ['ad','dw','st_low','st_high','fig','mycat_high']:
        _rt_dic = get_result(rt,name)
    
    for k,v in _rt_dic.items():
        print "%s->%s" %(k,v)
