#!/bin/bash


IPADDR=192.X.X.10

`rm -rf 503.txt`

tail -n5 /etc/httpd/logs/access_log | awk '{ if($9 == 503) { print $1 } }' > 503.txt

count=`cat 503.txt | wc -l`

if [ "$count" -ge "4" ]
then

IP=`cat 503.txt |tail -n1 | awk '{print $1}'`

if [ "$IP" == "$IPADDR" ]
 then


echo "Found 503!!!!!!! Some internal Error Occured"

fi

fi
