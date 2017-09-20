#!/usr/bin/env python
#fileencoding:utf-8
URL = 'http://sendsms.api.com/api/index.php?username=adfasdfa&pwd=fdafasdfa&postfix=【中国电信】'
import sys
import urllib
import urllib2
import time

def sendsms(phone,test,message):
        data = {'message':message, 'test':test,'phone':phone}
        body = urllib.urlencode(data)

        request = urllib2.Request(URL,body)
        urldata = urllib2.urlopen(request)

        print urldata.read()

if __name__ == '__main__':
        sendsms(sys.argv[1],sys.argv[2], sys.argv[3])
