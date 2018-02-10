#!/usr/bin/env python
#coding:utf-8

import simplejson as json
import argparse
import urllib2
import os


class LjStatics(object):

    def __init__(self,api_url):

        html = urllib2.urlopen(api_url)
        strJson = "".join([ html.read().strip().rsplit("}" , 1)[0] ,  "}"] )
        #with open('/etc/zabbix/externalscripts/lj.json','w+') as f:
        #    f.write(strJson)
        global hjson
        hjson = json.loads(strJson)
        #hjson = self.get_json_data()

    def get_json_data(self):
        jsondata = json.load(file("/etc/zabbix/externalscripts/lj.json"))
        return  jsondata

    def get_role_list(self):
        return hjson.keys()

    def get_role_uptime(self,arg):
        self.arg = args.uptime

        return hjson[arg]['update_time']

    def get_global_role_list(self):
        g_list = []

        g_list = hjson['global']['status'].keys()
        return g_list

    def get_global_role_status(self,arg,item):
        self.arg = args.glbstatus
        self.item = args.gitem

        for key in hjson['global']['status'].keys():
            if key == arg:
                return hjson['global']['status'].get(key).get(item)

    def get_region_role_id(self):
        _id_list = []
        for role in hjson['region']['status']:
            _id_list.append(role['id'])
        return _id_list

    def get_regin_role_list(self):
        r_list = []
        for role in hjson['region']['status']:
            region_id = role['id']
            for r_role in role['status']:
                if r_role['type_name'] == 'location':continue
                r_list.append(r_role['type_name']+'-'+str(region_id)+'-'+str(r_role['instance_id']))
        return r_list
    
    def get_regin_role_lld(self):
        r_list = self.get_regin_role_list()
        _rts = []
        for _rt in  r_list:
            r = os.path.basename(_rt.strip())
            _rts += [{'{#SERVERID}':r}]
        return json.dumps({'data':_rts},sort_keys=True,indent=4,separators=(',',':'))

   
    def get_region_location_lld(self):
        r_list = []
        for role in hjson['region']['status']:
            region_id = role['id']
            for r_role in role['status']:
                if r_role['type_name'] != 'location':continue
                r_list.append(r_role['type_name']+'-'+str(region_id)+'-'+str(r_role['instance_id']))
        _rts = []
        for _rt in  r_list:
            r = os.path.basename(_rt.strip())
            _rts += [{'{#SERVERID}':r}]
        return json.dumps({'data':_rts},sort_keys=True,indent=4,separators=(',',':'))

    def get_regin_role_status(self,arg,item):
        self.arg = args.regstatus
        self.item = args.item
        region_id = int(arg.split('-')[1])
        _id = int(arg.split('-')[2])
        _arg = arg.split('-')[0]

        for role in hjson['region']['status']:
            if role['id'] == region_id:
                for r_role in role['status']:
                    if r_role['type_name'] == _arg and r_role['instance_id'] == _id:
                        return r_role['status'][item]

    @staticmethod
    def parse_args():
        parser = argparse.ArgumentParser()

        help = 'Get role list'
        parser.add_argument('-rl','--getrole', help=help)

        help = 'Get global role list '
        parser.add_argument('-gbl','--getglist', help=help)

        help = 'The global role status'
        parser.add_argument('-grs','--glbstatus', help=help)

        help = 'The global role status item'
        parser.add_argument('-gi','--gitem', help=help)

        help = 'Get regin role list'
        parser.add_argument('-grl','--getrlist', help=help)

        help = 'Get regin role low discovery'
        parser.add_argument('-grlll','--getrll', help=help)

        help = 'Get regin location role list'
        parser.add_argument('-grll','--getrllist', help=help)

        help = 'The regin role status'
        parser.add_argument('-rs','--regstatus', help=help)

        help = 'The regin role status item'
        parser.add_argument('-i','--item', help=help)

        help = 'Get the role uptime'
        parser.add_argument('-u','--uptime', help=help)

        args = parser.parse_args()
        return args

if __name__ == '__main__':
    '''
    python ljstatics.py -rl 1   #获取所有角色列表
    python ljstatics.py -gbl 1  #获取所有global列表
    python ljstatics.py -grl 1  #获取所有region列表
    python ljstatics.py -gbll 1 #获取所有location的LLD值
    python ljstatics.py -grs feedback -gi http_total_req #获取global里面的某个角色的监控项
    python ljstatics.py -rs queue -i total_send_message  #获取region里面queue的监控项total_send_message

    全局和除location以外的，只能通过具体监控项参数进行添加
    location1-15，可以通过LLD功能进行监控项添加
    LLD适用场景：对于同一对象，有相同的指标值。例如：采集每个磁盘的IO参数。
   '''
   
    api_url = 'http://10.20.122.9:10200/GetMonitorData'
    lj = LjStatics(api_url)

    args = lj.parse_args()
    #获取整体角色列表[region、global、ret]
    if args.getrole:
        print lj.get_role_list()

    #获取global角色列表gbl
    elif args.getglist:
        print lj.get_global_role_list()

    #获取region角色列表grl
    elif args.getrlist:
        print lj.get_regin_role_list()

    #获取region里面的location自动发现项 grll
    elif args.getrllist:
        print lj.get_region_location_lld()

    #获取region里面的location自动发现项 grll
    elif args.getrll:
        print lj.get_regin_role_lld()

    #获取全局角色及监控项值  grs  gi
    elif args.glbstatus and args.gitem:
        print lj.get_global_role_status(args.glbstatus,args.gitem)

    #获取region角色及监控项值  rs i
    elif args.regstatus and args.item:
        print lj.get_regin_role_status(args.regstatus,args.item)

    #获取角色uptime
    elif args.uptime:
        print lj.get_role_uptime(args.uptime)

    else:
        print 'null'





