#!/bin/bash

mysqldump -uroot -pPassword1 dbname1 > dbname1`date +"%F:%H:%M:%S"`.sql 2> /dev/null
sleep 10
mysqldump -uroot -pPassword2 dbname2 > dbname2`date +"%F:%H:%M:%S"`.sql 2> /dev/null
cd /root/Sri/DBBackup/
sleep 20
find . -mtime +2 -name '*.sql' -exec rm -rf {} \;
