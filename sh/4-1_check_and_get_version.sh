#!/bin/bash
#: Script Name: 4-1_check_and_get_version_test.sh
#: Authors: Andrew Zhang
#: Reviewers:
#: Date: 10/20/2015
#: Purpose: Login to the target machine and get the version log file.
#: Note: Need one parameter one for the command line 
#: For example: ./4-1_check_and_get_version_test.sh ../txt/hostname_QA.txt 

NUMOFLINES=$(wc -l < "$1")
I=1


for hostname in $(cat $1); do
    echo "******************************************************";
    echo "***INFO: Connecting to $hostname and copy log file ***";
    echo "***  Processing station $I of $NUMOFLINES set          ***"
    echo "******************************************************";
    
    ssh -o ConnectTimeout=20 genia@$hostname 'cd ~/Installation; timeout 65 ./get_verion.sh'  
    sleep 10
    timeout 10 rsync genia@$hostname:/home/genia/Installation/*version*.log ../log 

    echo "******************************************************";
    echo "Done installing  on $hostname"
    echo "******************************************************";
    I=$(($I+1))
done
wait
echo "WARNING: Done with cheking the versions from All stations"

