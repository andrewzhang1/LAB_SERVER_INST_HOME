#!/bin/bash

# Use this script to create a versioned build
# of genia_one software and FPGA firmware.

# Version and build software
#svn co svn+ssh://192.168.150.50/home/svn/genia_one_software 
#cd ./genia_one_software/trunk/embedded
#./build
#cd ../../../

#mkdir software
#cp -r ./genia_one_software/trunk/embedded/bin ./genia_one_software/trunk/embedded/dma_kernel_module ./software

# Version and Build FPGA firmware
# FIXME: This needs to support tagged versions.
#source /home/genia/Xilinx/Vivado/2013.2/settings64.sh
#mkdir -p genia_one_fpga
#cd genia_one_fpga
#svn co svn+ssh://192.168.150.50/home/svn/genia_one_fpga/trunk/mendel
#cd mendel/synth/build
#make
#cd ../../../../

# Get docs
#svn co svn+ssh://192.168.150.50/home/svn/genia_one_utilities/trunk/docs

# Build release archive
#date=$(date +%F)
#echo $date

#tar -czvf genia_one_release_$date.tar.gz ./docs/uci_sys_spec.rtf ./docs/UCI_Datafile_Format.txt ./software -C ./genia_one_fpga/mendel/synth/build/results mendel.bit -C ../../scripts burn_fpga_rom.sh genia_impact_script.cmd --exclude-vcs

#echo Release archive created in ./genia_one_release_$date.tar.gz

if [ -z "$1" ];
  then
    echo "ERROR: Version is missed or $1 is incorrect."
    exit 1
fi

if [ -z "$2" ];
  then
    echo "ERROR: release\candidate param is missed or $2 is incorrect."
    exit 1
fi

if [ "$2" = "candidate" -o "$2" = "release" ];
  then
    if [ "$2" = "candidate" ];
      then
        if [ -z "$3" ];
          then
          echo "INFO: TAG param is missed. The 'trunk' is set by default for candidate."
          LabcodesRepo="trunk"
        else
          echo "WARNING: Candidate package will include the custom TAG: $3"
          LabcodesRepo=$3
        fi
    elif [ -z "$3" ];
        then
        echo "WARNING: TAG param is missed. TAG name is required for 'release' type of packages, please specify it."
        exit 1
    else 
      LabcodesRepo=$3 
    fi
else
   echo "ERROR! $2 is not proper format of the release\candidate param."
   exit 1
fi




echo "Would you like to create a tar file for version: $1 as $2 with TAG ${LabcodesRepo}"
read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Nn]$ ]]
then
    exit 2
fi


# System Release Version
#rel_ver="2_5"
rel_ver=$1
#LabcodesTagName="2015_10_06_release_dev"

#LabcodesRepo="tags/2015_10_06_release_dev"
#LabcodesRepo="trunk"

#svn checkout the tagged labcodes
rm -rf /home/genia/jenkins/builds/labcodes
mkdir /home/genia/jenkins/builds/labcodes
cd /home/genia/jenkins/builds/labcodes
#svn co svn+ssh://genia@svn.rsc.roche.com/home/svn/genia_one_labcodes/tags/${LabcodesTagName}  /home/genia/jenkins/builds/labcodes
svn co svn+ssh://genia@svn.rsc.roche.com/home/svn/genia_one_labcodes/${LabcodesRepo}  /home/genia/jenkins/builds/labcodes
svn info >> /home/genia/jenkins/builds/version_info.txt


#svn checkout the labcodes_sandbox
rm -rf /home/genia/jenkins/builds/labcodes_sandbox
mkdir /home/genia/jenkins/builds/labcodes_sandbox
cd /home/genia/jenkins/builds/labcodes_sandbox
svn co svn+ssh://genia@svn.rsc.roche.com/home/svn/genia_labcodes_sandbox/trunk/labcodes_sandbox  /home/genia/jenkins/builds/labcodes_sandbox
svn info >> /home/genia/jenkins/builds/version_info.txt

cd /home/genia/jenkins/builds

#Copy station software to Genia_one folder
rm -rf genia_one
mkdir -p genia_one/docs
cp ./docs/uci_sys_spec.rtf ./genia_one/docs
cp ./docs/UCI_Datafile_Format.txt ./genia_one/docs
cp ./genia_one_fpga/mendel/synth/build/results/mendel.bit ./genia_one
cp ./genia_one_fpga/mendel/synth/scripts/burn_fpga_rom.sh ./genia_one
cp ./genia_one_fpga/mendel/synth/scripts/genia_impact_script.cmd ./genia_one
cp -r ./software ./genia_one

#Create the TAR ball
#tar -czvf station_v${rel_ver}_release.tar.gz ./docs/uci_sys_spec.rtf ./docs/UCI_Datafile_Format.txt ./software ./labcodes ./labcodes_sandbox -C ./genia_one_fpga/mendel/synth/build/results mendel.bit -C ../../scripts burn_fpga_rom.sh genia_impact_script.cmd --exclude-vcs
echo "INFO: Creating a TAR file(package)"
tar -czvf station_v${rel_ver}_$2.tar.gz ./genia_one ./labcodes ./labcodes_sandbox ./version_info.txt
rm /home/genia/jenkins/builds/version_info.txt

#check into SVN repo:  

# 10/21/2015 Comment out the following line:  Added by Andrew


echo "INFO: SVN CO Repo"
cd /home/genia/jenkins/builds/current_svn
svn co svn+ssh://genia@svn.rsc.roche.com/home/svn/genia_one_releases/station_releases/
cd /home/genia/jenkins/builds/current_svn/station_releases/

if [ -f station_v${rel_ver}_$2.tar.gz ]
 then
   echo "INFO: Updating the TAR file"
   cp -f ../../station_v${rel_ver}_$2.tar.gz /home/genia/jenkins/builds/current_svn/station_releases/
 else
   echo "INFO: Adding the TAR file to new release."
   cp -f ../../station_v${rel_ver}_$2.tar.gz /home/genia/jenkins/builds/current_svn/station_releases/
   cd /home/genia/jenkins/builds/current_svn/station_releases/
   svn add station_v${rel_ver}_$2.tar.gz
fi 

echo "INFO: Commit the TAR file to SVN"
cd /home/genia/jenkins/builds/current_svn/station_releases/
svn commit -m "New TAR file $1 by $2 with TAG ${LabcodesRepo} "

echo Release archive created in ./station_v${rel_ver}_$2.tar.gz


# Cleanup
#rm ./genia_one_software ./genia_one_fpga ./docs ./software -rf
