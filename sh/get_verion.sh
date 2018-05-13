#!/bin/bash
#: Authors: Andrew Zhang
#: Script Name: get_verion.sh
#: Reviewers:
#: Date: 10/08/2015
#: Purpose:  Retrieve version number from the work station.
#: Updated:

logf="`hostname`_version_`date +%Y%m%d`.log"
echo "Software Version on `hostname` are: " > $logf
echo "####################################" >> $logf

# 1. Check version for FPGA:
##############################

# Check if the genia_connection: No needed now.
#if ps cax | grep genia_connect ; then
#    echo "The genia_connection is running!"
#    echo "Shutdown genia_Connection"
#    cd  /home/genia/projects/genia_one/software/bin
#    ./genia_quit
#else
#   echo "No genia_connection is running!"
#fi

# Lauch genia_connection to chec the version
cd /home/genia/projects/genia_one/software/bin
#./genia_quit
#sleep 3

./genia_connect &  
sleep 2

echo "The FPGA version is:" >> /home/genia/Installation/$logf
./getversion  >> /home/genia/Installation/$logf

./genia_quit
sleep 3

##############################
# 2. Check labcodes version:
##############################
echo ""  >> /home/genia/Installation/$logf
echo "The labcodes version is: "  >> /home/genia/Installation/$logf
echo "####################################" >> $logf
echo ""
cd /home/genia/projects/labcodes
svn info >> /home/genia/Installation/$logf
echo "Done!"

