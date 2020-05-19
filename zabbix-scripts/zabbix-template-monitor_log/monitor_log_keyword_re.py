#coding:utf-8
#!/usr/bin/env python


######################################
# 统计日志中文件中关键字出现的次数
# $1, 日志路径
# $2, 关键字
# 
# Tips:
# 1. 每次执行该函数只统计新增的日志行(已统计到的日志行数会记录)
# 2. 如果是在不同的 PWD 下执行该函数则不会相互影响
# 3. 该函数设计是 1分钟执行一次，如果检测到最后一次执行是2分钟以前则会重新从日志当前位置开始处理
# 
import os
import time
import sys
import hashlib
import datetime
import re
import logging

MAX_TIME_OFFSET = 60 * 2

#logging.basicConfig(level=logging.INFO)
log_file, keywords = sys.argv[1], sys.argv[2] 

h = hashlib.md5()
h.update(log_file + os.getcwd())
pos_file = os.path.join("/tmp/", "%s_%s.pos" % (h.hexdigest(), os.path.basename(log_file)))

log_st = os.stat(log_file)
#logging.info("log file stat: %s", log_st)

log_size = log_st.st_size

#如果采集数据时，发现是2分钟以内数据，则承接上次取值位置开始
if os.path.exists(pos_file) and time.time() - os.stat(pos_file).st_mtime <= MAX_TIME_OFFSET:
    pos_fd = open(pos_file, "r+")
    start_pos = int(pos_fd.read())
    logging.info("read pos file: start_pos: %s", start_pos)
#如果采集数据时，发现是2分钟以前的数据，则从当前位置开始，每分钟取一次的话，2分钟以前的肯定是老数据了
else:
    pos_fd = open(pos_file, "w")
    start_pos = log_size

#logging.info("write pos file: %s", "%d" % log_size)
#将本次的位置写入文件
pos_fd.seek(0)
pos_fd.truncate(0)
pos_fd.write("%d" % log_size)
pos_fd.close()

#如果发现当前位置大于文件长度，则将当前位置置零，也就是跑到文件最顶端
if start_pos > log_size:
    logging.info("start_pos(%d) > log_size(%d), set 0", start_pos, log_size)
    start_pos = 0
#logging.info("log size: %s, start_pos: %s", log_size, start_pos)

count = {keywords:0}
#将文件内容寄存行
log_fd = open(log_file, "r", 1)
#将文件指针跑到末尾
log_fd.seek(start_pos-log_size, 2)

re_com = re.compile(keywords)

#取寄存行的内容，并匹配关键字
for line in log_fd:
    if re_com.search(line):
        #print line
        count.setdefault(keywords, 0)
        count[keywords] += 1
logging.info("count: %s", count)
print count[keywords]

