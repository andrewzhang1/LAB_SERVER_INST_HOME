#!/bin/bash
#: Script Name: 3-install_Conncurrent.sh
#: Authors: Andrew Zhang, Alex Grytsyna
#: Reviewers:
#: Date: 10/08/2015
#: Purpose: Ccontrol the installation for FPGA and labcodes.
#: Note: Need one parameter one for the command line 
#: 	     for the machine list 

#: How to run on command line: ./3-install_Conncurrent.sh ../txt/hostnames_QA.txt



NUMOFLINES=$(wc -l < "$1")
I=1

for hostname in $(cat $1); do 

    echo "*************************************************************"
    echo "*** INFO: Connecting to $hostname and install FPGA and labcodes ***"
    echo "*** Processing station $I of $NUMOFLINES set              ***"
    echo "*************************************************************"
    
   ssh -o ConnectTimeout=20 genia@$hostname 'cd ~/Installation; ./install.sh; sleep 10 ' &

    echo "*************************************************************"
    I=$(($I+1))

done
wait
echo "WARNING: Done with installation on $NUMOFLINES station(s)"

