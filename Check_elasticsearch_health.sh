#!/bin/bash

#################################
##Nagios Plugin for Elasticsearch
## --Sri
#################################


#Variables declaration
STATUS_OK=0              # exit code if status is OK
STATUS_WARNING=1         # exit code if status is Warning
STATUS_CRITICAL=2        # exit code if status is Critical
STATUS_UNKNOWN=3
port=9200


#Functions
help () {
echo -e "Usage: ./check_es_system.sh -H <IpAddress> -P <Port_number> -t <type>

Options:

     -H Hostname or ip address of ElasticSearch Node
     -P Port (defaults to 9200)
     -t type (health or stats)
     -h Help!
"
exit $STATUS_UNKNOWN;
}

#Help function goes here
if [ "${1}" = "--help" -o "${#}" = "0" ]; then help; exit $STATUS_UNKNOWN; fi

# Get user-given variables
while getopts "H:P:t:" Input;
do
  case ${Input} in
  H)      host=${OPTARG};;
  P)      port=${OPTARG};;
  t)      flag=${OPTARG};;
  *)      help;;
  esac
done


# Check for mandatory opts
if [ -z ${host} ]; then help; exit $STATE_UNKNOWN; fi
if [ -z ${flag} ]; then help; exit $STATE_UNKNOWN; fi

if [ "$flag" == "health" ]
then
eurl=`curl http://$host:$port/_cluster/health | jq '.status'`

#echo $STATUS
if [ "$eurl" == "\"green\"" ]
then
echo "$STATUS_OK: Found status as $eurl | cluster_state=0;;;;"
exit 0
elif [ "$eurl" == "\"yellow\"" ]
then
echo "$STATUS_WARNING: Found status as $eurl | cluster_state=1;1;;;;"
exit 1
elif [ "$eurl" == "\"red\"" ]
then
echo "$STATUS_CRITICAL: Found status as $eurl | cluster_state=2;1;2;;;"
exit 2
else
echo "$STATUS_UNKNOWN: Found status as $eurl | cluster_state=3;1;2;;;"
exit 3
fi
fi


if [ "$flag" == "stats" ]
then
total_nodes=`curl http://$host:$port/_cluster/stats | jq '._nodes.total'`
available_nodes=`curl http://$host:$port/_cluster/stats | jq '._nodes.successful'`

if [ "$total_nodes" -eq "$available_nodes" ]
then
echo "STATUS OK: ES Cluster have total $total_nodes nodes and Available $available_nodes nodes | cluster_status=0;;;;"
exit 0
elif [ "$available_nodes" -eq 2 ]
then
echo "STATUS WARNING: ES Cluster have total $total_nodes nodes and Available 2 nodes | cluster_status=1;1;;;;"
exit 1
elif [ "$available_nodes" -eq 1 ]
then
echo "STATUS CRITICAL: ES Cluster have total $total_nodes nodes and Available 1 nodes | cluster_status=2;1;2;;; "
exit 2
else
exit 3
fi
fi
