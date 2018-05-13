#!/bin/bash
#: Author: Andrew Zhang
#: Script name: 1_reboot_station.sh 
#: Reviewers:
#: Date: 10/20/2015
#: Purpose:   Reboot the machine with a list as a argument.
#: Note: Need one parameter one for the command line 
#: Command line: ./1_reboot_station.sh ../txt/hostnames_QA.txt



NUMOFLINES=$(wc -l < "$1")
I=1

for hostname in $(cat $1); do
    echo "******************************************************";
    echo "*** INFO: Connecting to $hostname and reboot now   ***";
    echo "***          process $I from $NUMOFLINES           ***";
    echo "******************************************************";
   
	ssh -o ConnectTimeout=20 genia@$hostname ' 
    sudo -S <<< "mooredna" reboot
	'	
    I=$(($I+1))
    echo "******************************************************";
    echo "*************    Done with rebooting *****************";
    echo "******************************************************";
done
wait
echo "WARNING: All stations have been rebooted"
