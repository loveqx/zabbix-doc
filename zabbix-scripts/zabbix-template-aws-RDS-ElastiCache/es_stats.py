#!/usr/bin/python
import datetime
import sys
from optparse import OptionParser
import boto3

### Arguments
parser = OptionParser()
parser.add_option("-i", "--instance-id", dest="instance_id",
                help="DBInstanceIdentifier")
parser.add_option("-a", "--access-key", dest="access_key", default="",
                help="AWS Access Key")
parser.add_option("-k", "--secret-key", dest="secret_key", default="",
                help="AWS Secret Access Key")
parser.add_option("-m", "--metric", dest="metric",
                help="RDS cloudwatch metric")
parser.add_option("-r", "--region", dest="region", default="us-east-1",
                help="RDS region")

(options, args) = parser.parse_args()

if (options.instance_id == None):
    parser.error("-i DBInstanceIdentifier is required")
if (options.metric == None):
    parser.error("-m RDS cloudwatch metric is required")
###

if not options.access_key or not options.secret_key:
    use_roles = True
else:
    use_roles = False

### Real code
metrics = {"CPUUtilization":{"type":"float", "value":None},
    "ReadLatency":{"type":"float", "value":None},
    "DatabaseConnections":{"type":"int", "value":None},
    "FreeableMemory":{"type":"float", "value":None},
    "ReadIOPS":{"type":"int", "value":None},
    "WriteLatency":{"type":"float", "value":None},
    "WriteThroughput":{"type":"float", "value":None},
    "WriteIOPS":{"type":"int", "value":None},
    "SwapUsage":{"type":"float", "value":None},
    "ReadThroughput":{"type":"float", "value":None},
    "DiskQueueDepth":{"type":"float", "value":None},
    "ReplicaLag":{"type":"int", "value":None},
    "DiskQueueDepth":{"type":"float", "value":None},
    "ReplicationLag":{"type":"int", "value":None},
    "NetworkReceiveThroughput":{"type":"float", "value":None},
    "NetworkTransmitThroughput":{"type":"float", "value":None},
    "FreeStorageSpace":{"type":"float", "value":None}}
end = datetime.datetime.utcnow()
start = end - datetime.timedelta(minutes=5)

### Zabbix hack for supporting FQDN addresses
### This is useful if you have instances with the same nam but in diffrent AWS locations (i.e. db1 in eu-central-1 and db1 in us-east-1)
if "." in options.instance_id:
    options.instance_id = options.instance_id.split(".")[0]

if use_roles:
    conn = boto3.client('cloudwatch', region_name=options.region)
else:
    conn = boto3.client('cloudwatch', aws_access_key_id=options.access_key, aws_secret_access_key=options.secret_key, region_name=options.region)

if options.metric in metrics.keys():
  k = options.metric
  vh = metrics[options.metric]
  
  try:
          res = conn.get_metric_statistics(Namespace="AWS/ElastiCache", MetricName=k, Dimensions=[{'Name': "CacheClusterId", 'Value': options.instance_id}], StartTime=start, EndTime=end, Period=60, Statistics=["Average"])
  except Exception as e:
          print("status err Error running rds_stats: %s" % e)
          sys.exit(1)
  datapoints = res.get('Datapoints')
  if len(datapoints) == 0:
      print("Could not find datapoints for specified instance. Please review if provided instance (%s) and region (%s) are correct" % (options.instance_id, options.region)) # probably instance-id is wonrg
      
  average = datapoints[-1].get('Average') # last item in result set
  if (k == "FreeStorageSpace" or k == "FreeableMemory"):
          average = average / 1024.0**3.0
  if vh["type"] == "float":
          metrics[k]["value"] = "%.4f" % average
  if vh["type"] == "int":
          metrics[k]["value"] = "%i" % average

  #print "metric %s %s %s" % (k, vh["type"], vh["value"])
  print("%s" % (vh["value"]))
