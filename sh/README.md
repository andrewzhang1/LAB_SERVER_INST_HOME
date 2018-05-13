############################################ 
# Genia Automatic Installation Instructions
# Version: 1.0
# Created by: Andrew Zhang
###########################################

In order to run the Jenkins controlled automatic installation concurrently
we created a set of scripts for this task.

All the scripts can be run ourside the Jenkins and run them sequentially.

If we want to run them outside the Jenkins, we can use the following steps.

1. Login to pallettown by user genia;
2. Please look into the scripts for the proper arguement; most script need to have 
one argument on the command line (the argument is a list of the lab machine name!)

/home/genia/GENIA_HOME/sh
(genia@pallettown)\>

0-export_tar.sh              ../txt/hostnames_QA.txt
1-reboot_station.sh          ../txt/hostnames_QA.txt
2-send_file_to_station.sh    ../txt/hostnames_QA.txt
3-install_Conncurrent.sh     ../txt/hostnames_QA.txt
4-1_check_and_get_version.sh ../txt/hostnames_QA.txt

Questions and advices are welcome!

