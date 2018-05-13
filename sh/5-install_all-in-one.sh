# This is an extra script, which can be run outside the Jenkins.
# Script Name: 5-install_all-in-one.sh
# 10/22/2015
# Andrew Zhang
# We might modify the timing, etc accordingly.

#set variables

export ver=$1
export list=$2

./0-export_tar.sh $ver

./1-reboot_station.sh ../txt/$list

echo "start now:"
date
sleep 1

echo "sleep after reboot at  120 end"

sleep 120

./2-send_file_to_station.sh ../txt/$list 


sleep 10
# 3- install concurently
echo "start now:"
./3-install_Conncurrent.sh ../txt/$list

echo "start now:"

sleep 400

echo "sleep end after 400 sec."

# Get versions

./4-1_check_and_get_version.sh ../txt/$list

