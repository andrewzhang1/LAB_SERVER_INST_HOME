#!/bin/bash
#: script name: 2_send_file_to_station.sh 
#: Authors: Andrew Zhang
#: Reviewers:
#: Date: 10/08/2015
#: Purpose: Send a few files remotely to all the lab machines.
#: Note: Need one parameter one for the command line 
#: 	 for the machine list 

#: Command line: ./2_send_file_to_station.sh ../txt/hostnames_QA.txt

NUMOFLINES=$(wc -l < "$1")
I=1

for hostname in $(cat $1); do
    echo "******************************************************";
    echo "*** INFO: Connecting to $hostname and deploy scripts ***";
    echo "*** Processing station $I of $NUMOFLINES set        ***";
    echo "******************************************************";
   
    ssh -o ConnectTimeout=4 genia@$hostname 'rm -rf /home/genia/Installation; mkdir -p /home/genia/Installation '
    scp -r install.sh  genia@$hostname:/home/genia/Installation 	    
    scp -r get_verion.sh genia@$hostname:/home/genia/Installation
    scp -r  ../build/station_release.tar.gz  genia@$hostname:/home/genia/Installation

echo " I am here!"
#sleep 2

    echo "******************************************************";
    echo "Done with transfering installation files to $hostname"
    echo "******************************************************";
    I=$(($I+1))
done
wait
echo "WARNING: Done with  transfering installation files to ALL stations"

