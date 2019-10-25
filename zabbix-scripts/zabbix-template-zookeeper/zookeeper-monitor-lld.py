#!/usr/bin/python  
import json
""" Check Zookeeper Cluster  

zookeeper version should be newer than 3.4.x  

# echo mntr|nc 127.0.0.1 2181  
zk_version  3.4.6-1569965, built on 02/20/2014 09:09 GMT  
zk_avg_latency  0  
zk_max_latency  4  
zk_min_latency  0  
zk_packets_received 84467  
zk_packets_sent 84466  
zk_num_alive_connections    3  
zk_outstanding_requests 0  
zk_server_state follower  
zk_znode_count  17159  
zk_watch_count  2  
zk_ephemerals_count 1  
zk_approximate_data_size    6666471  
zk_open_file_descriptor_count   29  
zk_max_file_descriptor_count    102400  

# echo ruok|nc 127.0.0.1 2181  
imok  

"""  
import sys  
import socket  
import re  
import subprocess  
from StringIO import StringIO  
import os  

zabbix_sender = '/usr/bin/zabbix_sender'  
zabbix_conf = '/etc/zabbix/zabbix_agentd.conf'  
send_to_zabbix = 1  
hostname = os.uname()[1]
############# get zookeeper server status  
class ZooKeeperServer(object):  

    def __init__(self, host='localhost', port='2181', timeout=1):  
        self._address = (host, int(port))  
        self._timeout = timeout  
        self._result  = {}  

    def _create_socket(self):  
        return socket.socket()  

    def _send_cmd(self, cmd):  
        """ Send a 4letter word command to the server """  
        s = self._create_socket()  
        s.settimeout(self._timeout)  

        s.connect(self._address)  
        s.send(cmd)  

        data = s.recv(2048)  
        s.close()  

        return data  

    def get_stats(self):  
        """ Get ZooKeeper server stats as a map """  
        data_mntr = self._send_cmd('mntr')  
        data_ruok = self._send_cmd('ruok')  
        if data_mntr:  
            result_mntr = self._parse(data_mntr)  
        if data_ruok:  
            result_ruok = self._parse_ruok(data_ruok)  

        self._result = dict(result_mntr.items() + result_ruok.items())

        if not self._result.has_key('zk_followers') and not self._result.has_key('zk_synced_followers') and not self._result.has_key('zk_pending_syncs'):  

           ##### the tree metrics only exposed on leader role zookeeper server, we just set the followers' to 0  
           leader_only = {'zk_followers':0,'zk_synced_followers':0,'zk_pending_syncs':0}      
           self._result = dict(result_mntr.items() + result_ruok.items() + leader_only.items() )  

        return self._result    

    def _parse(self, data):  
        """ Parse the output from the 'mntr' 4letter word command """  
        h = StringIO(data)  

        result = {}  
        for line in h.readlines():  
            try:  
                key, value = self._parse_line(line)  
                result[key] = value  
            except ValueError:  
                pass # ignore broken lines  

        return result  

    def _parse_ruok(self, data):  
        """ Parse the output from the 'ruok' 4letter word command """  

        h = StringIO(data)  

        result = {}  

        ruok = h.readline()  
        if ruok:  
           result['zk_server_ruok'] = ruok  

        return result  

    def _parse_line(self, line):  
        try:  
            key, value = map(str.strip, line.split('\t'))  
        except ValueError:  
            raise ValueError('Found invalid line: %s' % line)  

        if not key:  
            raise ValueError('The key is mandatory and should not be empty')  

        try:  
            value = int(value)  
        except (TypeError, ValueError):  
            pass  

        return key, value  

    def get_pid(self):  
#  ps -ef|grep java|grep zookeeper|awk '{print $2}'  
         pidarg = '''ps -ef|grep java|grep zookeeper|grep -v grep|awk '{print $2}' '''   
         pidout = subprocess.Popen(pidarg,shell=True,stdout=subprocess.PIPE)  
         pid = pidout.stdout.readline().strip('\n')  
         return pid  

    def send_to_zabbix(self, metric):  
         key = "zookeeper.status[" +  metric + "]"  

         if send_to_zabbix > 0:  
             #print key + ":" + str(self._result[metric])  
             try:  

                subprocess.call([zabbix_sender, "-c", zabbix_conf,"-s",hostname, "-k", key, "-o", str(self._result[metric]) ], stdout=FNULL, stderr=FNULL, shell=False)  
             except OSError, detail:  
                print "Something went wrong while exectuting zabbix_sender : ", detail  
         else:  
                print "Simulation: the following command would be execucted :\n", zabbix_sender, "-c", zabbix_conf, "-k", key, "-o", self._result[metric], "\n"  

def usage():  
        """Display program usage"""  

        print "\nUsage : ", sys.argv[0], " alive|all"  
        print "Modes : \n\talive : Return pid of running zookeeper\n\tall : Send zookeeper stats as well"  
        sys.exit(1)  

accepted_modes = ['alive', 'all']  

if len(sys.argv) == 2 and sys.argv[1] in accepted_modes:  
        mode = sys.argv[1]  
else:  
        usage()  

zk = ZooKeeperServer()  
#print zk.get_stats()
pid = zk.get_pid()  
#IFS=$'\n'


if pid != "" and  mode == 'all':  
   zk.get_stats()  
   FNULL = open(os.devnull, 'w') 
   for key in zk._result: 
       print key
       zk.send_to_zabbix(key)
   FNULL.close()  

ip_list = []
data_json = {}
for result in zk._result:
    ip_dic={}
    ip_dic["{#ZOOKEEPER}"]=result
    ip_list.append(ip_dic)
data_json['data']=ip_list
 
result = json.dumps(data_json,sort_keys=True, indent=4)
print result


