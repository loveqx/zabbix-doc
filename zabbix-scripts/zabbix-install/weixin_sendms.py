#!/usr/bin/env python
#fileencoding:utf-8
import sys
import urllib2
import time
import json
import requests
import requests.packages.urllib3
requests.packages.urllib3.disable_warnings()
reload(sys)
sys.setdefaultencoding('utf-8')

title = sys.argv[2]   # 位置参数获取title 适用于zabbix
content = sys.argv[3] # 位置参数获取content 适用于zabbix


class Token(object):
    # 获取token
    def __init__(self, corpid, corpsecret):
        self.baseurl = 'https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={0}&corpsecret={1}'.format(
            corpid, corpsecret)
        self.expire_time = sys.maxint

    def get_token(self):
        if self.expire_time > time.time():
            request = urllib2.Request(self.baseurl)
            response = urllib2.urlopen(request)
            ret = response.read().strip()
            ret = json.loads(ret)
            if ret['errcode'] != 0:
                print >> ret['errmsg'], sys.stderr
                sys.exit(1)
            self.expire_time = time.time() + ret['expires_in']
            self.access_token = ret['access_token']
        return self.access_token


def send_msg(title, content):
    # 发送消息
    corpid = "88888888888888"  # 填写自己应用的
    corpsecret = "88888888888888888888888888888" # 填写自己应用的
    qs_token = Token(corpid=corpid, corpsecret=corpsecret).get_token()
    url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token={0}".format(
        qs_token)
    payload = {
        "toparty": "2",
        "msgtype": "text",
        "agentid": "1",
        "text": {
                   "content": "{0}\n {1}".format(title, content)

        },
        "safe": "0"
    }
    ret = requests.post(url, data=json.dumps(payload, ensure_ascii=False),verify=False)
    with open('weixin.txt','a+') as f:
        f.write(ret.content)
    print ret.json()

def get_agent_list():
    corpid = "8888888888888"  # 填写自己应用的
    corpsecret = "8888888888888888888888888888888888888" # 填写自己应用的
    qs_token = Token(corpid=corpid, corpsecret=corpsecret).get_token()
    url = "https://qyapi.weixin.qq.com/cgi-bin/agent/list?access_token={0}".format(
        qs_token)
    ret = requests.get(url,verify=False)
    print ret.content
if __name__ == '__main__':
    # print title, content
    #get_agent_list()
    send_msg(title, content)
    #t=Token("8888888888","8888888888888888888888888888888")
    #print t.get_token()
