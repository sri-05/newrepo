#!/bin/bash

mysqldump -uroot -pPassword1 dbname1 > dbname1`date +"%F:%H:%M:%S"`.sql 2> /dev/null
sleep 10
