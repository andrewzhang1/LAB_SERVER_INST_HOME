#!/bin/bash
#: Scirpt Name: install.sh
#: Use pre-built *.gz file instead of that from svn directly
#: Created on 10/20/2015, Andrew Zhang
#: Updated on 10/29/2015, Alex Grytsyna
#: Script name: 1_reboot_station.sh 
#: Reviewers:
#: Modificati$on History:
#: 10/27/2015 Andrew
#:    1. Added backing up for the labcodes_sandbox;
#:    2. Still need to run "svn update" and "updatelabcode.sh" 
#:       in order to install latest labcodes.
#: 10/29/2015 Alex Grytsyna
#:    1. Added svn upgrade command for labcodes_sandbox
#:    2. Added host name for logging
#:


###########################################################################################
# Script to install FGPA on local machine, this is based on the Jenkins deployment scripts,
# but we use a pre-build station_release.tar.gz, which reduces the deployment time. 
###########################################################################################


# Copy the pre-build package for FPGA and labcodes:
cp station_release.tar.gz /home/genia/projects

host=$(hostname -f)
logf="`hostname`_FPGA_version_`date +%Y%m%d`.log"

# Add code for sshpass
sudo -S <<< "mooredna" touch test 

echo "********** Backup on $host **********"

# Change directory to /home/genia/projects
 cd /home/genia/projects
# Backup existing labcodes directory, rename to labcodes_backup_$date
if [ -d ./labcodes ]; then
    date=$(date +%F_%H%M)
    # Create the backup folder if it does not exist
    if [ ! -d ./backup ]; then
       mkdir backup
    fi
       mv ./labcodes ./backup/labcodes_backup_$date
      echo "Backup of labcodes on $host completed"
    fi

# Backup existing labcodes_sandbox directory, rename to labcodes_sandbox_backup_$date
if [ -d ./labcodes_sandbox ]; then
        date=$(date +%F_%H%M)
        # Create the backup folder if it does not exist
        if [ ! -d ./backup ]; then
             mkdir backup
        fi
        mv ./labcodes_sandbox ./backup/labcodes_sandbox_backup_$date
        echo "Backup of labcodes_sandbox on $host completed"
fi

# Clean up existing genia_one_releases folder
rm -rf /home/genia/projects/labcodes
rm -rf /home/genia/projects/labcodes_sandbox

# BACKUP EXISTING GENIA_ONE DIRECTORY AND REMOVE EXISTING GENIA_ONE_RELEASES DIRECTORY
if [ -d ./genia_one ]; then
    date=$(date +%F_%H%M)
    mv ./genia_one ./backup/genia_one_backup_$date
    echo "Backup of genia_one on $host completed"
fi

if [ -d ./genia_one ]; then
    date=$(date +%F_%H%M)
    mv ./genia_one ./backup/genia_one_backup_$date
    echo "Backup complete"
fi

# Clean up existing genia_one_releases folder
rm -rf /home/genia/projects/genia_one_releases


#echo "Goodbye root@${ReaderStation}"
echo "The backup of genia_one on $host was created! "
# exit 0

# Part 3 (pallettown)
#####################################################
# Execute shell script on the remte host using ssh:
#####################################################
#SECURE COPY SVN CHECKOUT TO READER STATION

#scp -r /var/lib/jenkins/jobs/${JOB_NAME}/workspace/genia_one_releases root@${ReaderStation}:/home/genia/projects

#cd /home/genia/projets

#svn export svn+ssh://svn.rsc.roche.com/home/svn/genia_one_releases/10-12-15/genia_one_release_2015-10-12.tar.gz

#echo "tar file has been exported from the SVN succesfully"

#Part 4 (runs on remote station)

# UNPACK AND INSTALL
#cd /home/genia/projects
# mkdir genia_one
# tar -C ./genia_one -xvzf ./genia_one_releases/${BuildDate}/genia_one_release_${TarDate}.tar.gz
# tar -C ./genia_one -xvzf ./genia_one_release_2015-10-12.tar.gz

#tar -xvzf station_v2_4_release.tar.gz 
echo "unpaking the tar.gz file on $host"
tar -xvzf station_release.tar.gz >> /home/genia/Installation/$logf

echo "********** SVN UPGRADE OF LABCODES ON $host **********"
cd /home/genia/projects/labcodes
# Update SVN format
svn upgrade >> /home/genia/Installation/$logf
svn info >> /home/genia/Installation/$logf
#RUN UPDATELABCODES.SH
./updatelabcode.sh >> /home/genia/Installation/$logf

cd /home/genia/projects/labcodes_sandbox
# Update SVN format
svn upgrade >> /home/genia/Installation/$logf
svn info >> /home/genia/Installation/$logf
#RUN UPDATELABCODES.SH
./updatelabcode.sh >> /home/genia/Installation/$logf


cd /home/genia/projects

#rm ./genia_one_releases -rf

echo "********** START MAKE FPGA ON $host **********"

cd ./genia_one/software/dma_kernel_module/Linux
make >> /home/genia/Installation/$logf
cd ../../..
#sshpass -p mooredna ./burn_fpga_rom.sh
echo "********** START BURN FPGA on $host **********"
sudo -S <<< "mooredna" ./burn_fpga_rom.sh >> /home/genia/Installation/$logf

cd ../
sudo -S <<< "mooredna" chown -R genia:genia ./genia_one

if [ -d ./genia_one_backup_$date ]; then
    sudo -S <<< "mooredna"  chown -R genia:genia ./genia_one_backup_$date
fi
echo "********** cap_set on $host **********"
cd ./genia_one/software/bin
#sudo ./cap_set.sh
sudo -S <<< "mooredna" ./cap_set.sh >> /home/genia/Installation/$logf

echo "FPGA has been updated on $host. REBOOTING the $host"
sudo -S <<< "mooredna"  reboot


