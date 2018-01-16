#!/bin/bash


Tomcat=/Path/to/tomcat
server1=/Path/to/server1
server2=/Path/to/server2
server1_name=server1_name
server2_name=server2_name
screen_name_of_server2=server2_screen_name
screen_name_of_server1=server1_screen_name

########Shutdown tomcat ##############

cd $Tomcat/bin/
./shutdown.sh

sleep 2
ps -ef | grep java | grep $Tomcat/bin > /dev/null

if [ "$?" -eq "0" ]
then
 pid_of_tomcat=`ps -ef | grep java | grep $Tomcat/bin | awk '{print $2}'`
 
 kill -9 $pid_of_tomcat 2> /dev/null
fi

##########Wait for 2min######################

sleep 60

###########Stop the server1################

pid_of_server1=`ps -ef | grep java | grep $server1_name | awk '{print $2}'`
 #Kill the process if running
     kill -9 $pid_of_server1 2> /dev/null >/dev/null
        sleep 1
        Wipe=`screen -ls | grep $screen_name_of_server1 | awk '{print $1}'`
        screen -wipe $Wipe > /dev/null 2> /dev/null
	sleep 2
 	screen -X -S $Wipe kill > /dev/null 2>/dev/null

sleep 60

############ Restart the Server2##############

 pid_of_server2=`ps -ef | grep java | grep $server2_name | awk '{print $2}'`
#Kill the process if running and restart the service
     kill -9 $pid_of_server2 2> /dev/null >/dev/null
        sleep 1
        Wipe=`screen -ls | grep $screen_name_of_server2 | awk '{print $1}'`
	screen -wipe $Wipe > /dev/null 2> /dev/null
	sleep 2
        screen -X -S $Wipe kill > /dev/null 2>/dev/null
		
		sleep 10
		
  cd $server2

  screen -A -m -d -S $screen_name_of_server2 java -jar $server2_name

  sleep 10
  
##############Start The server1##############

cd $server1

  screen -A -m -d -S $screen_name_of_server1 java -jar $server1_name

############Start the tomcat#####################
sleep 10

cd $Tomcat/bin/
./startup.sh





