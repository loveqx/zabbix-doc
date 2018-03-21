#!/bin/bash
 
ipaddr_shhb=`ip a| grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"|grep -E "42.82.92\.|125.63.12\."|wc -l`
ipaddr_shhb_proxy='42.82.92.22'
 
ipaddr_gzqxg=`ip a| grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"|grep -E "120.2.9\.|121.13.1\."|wc -l`
ipaddr_gzqxg_proxy='121.114.30.25'
 
 
ipaddr_hk=`ip a| grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"|grep -E "124.12.39\.|11.23.21\."|wc -l`
ipaddr_hk_proxy='124.12.39.33'
 
function install_agent() {
 
  wget http://安装机:端口/zabbix/zabbix-2.2.4-agent.sh
  /bin/bash zabbix-2.2.4-agent.sh uninstall $1
  /bin/bash zabbix-2.2.4-agent.sh install_proxy_agent  $1
  rm -rf zabbix-2.2.4-agent.sh
 
 
}
 
if [ ${ipaddr_shhb} -ge 1 ];then
 
    install_agent ${ipaddr_shhb_proxy}
 
elif [ ${ipaddr_gzqxg} -ge 1 ];then
    
    install_agent ${ipaddr_gzqxg_proxy}
else
    install_agent ${ipaddr_hk_proxy}
 
fi
