# This script is to create a *.tar.gz file based on the 
# most current release.
# Version 1.0
# Data: 10/22/2015

cd /home/genia/GENIA_INST_HOME/build/

export version=$1
#export reltype=$2

if [ -f station_release.tar.gz ]; then
        rm -rf station_release.tar.gz
fi

if [ -f station_v${version}_$2.tar.gz ]; then
        rm -rf station_v${version}_$2.tar.gz
fi

sshpass -p 'mooredna' svn export svn+ssh://genia@svn.rsc.roche.com:/home/svn/genia_one_releases/station_releases/station_v${version}_$2.tar.gz

echo "INFO: INITIAL TAR FILE is station_v$1_$2.tar.gz"

mv  station_v${version}_$2.tar.gz station_release.tar.gz

echo "************ WARNING: Tar file has been extracted **************"
