#!/usr/bin/env python
import commands
import sys

argv1=sys.argv[1]
argv2=sys.argv[2]
status = " /bin/echo 'db.serverStatus().%s' |/usr/bin/mongo admin  --port %s|grep -vE 'bye|admin|version'" %(sys.argv[2],sys.argv[1])
s,r=commands.getstatusoutput(status)
if r.startswith('Number') or r.startswith('ISODate'):
    cmd = "echo '%s' |awk -F[,\(\)] '{print $2}'" %r
    s,r=commands.getstatusoutput(cmd)
    print r
elif r.strip().isdigit():
    print r
else:
    print r

