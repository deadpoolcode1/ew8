#!/bin/sh

#set -x

swufile="update.swu"
SCRIPT_DIR="/opt/updater/scripts"
source $SCRIPT_DIR/updater_environment.sh
read_env_variables
next_fw_part_index=`swap_fw_partition_index $fw_partition_index`
next_media_part_index=`swap_media_partition_index $media_partition_index`
szpath="/sys/class/block/mmcblk0p$next_fw_part_index/size"
mdpath="/sys/class/block/mmcblk0p$next_media_part_index/size"
fwpart=`awk '{ print $1*512 }' $szpath`
mdpart=`awk '{ print $1*512 }' $mdpath`
DOWNLOAD_PATH="/opt/updater/download"

BLOB_VERSION=`cat < "$DOWNLOAD_PATH"/"_version"`

swufile="$DOWNLOAD_PATH"/"$BLOB_VERSION"/update.swu
echo $DOWNLOAD_PATH
echo $BLOB_VERSION
mkdir temp
cd temp
cpio -i < $swufile
if [ $? -ne 0 ]
then
   echo "Error in .swu archive"
   echo -n "error" > $DOWNLOAD_PATH/$BLOB_VERSION/status
   rm *
   cd ..
   rmdir temp
   exit 1
fi
fwsz=`gunzip -l firmware.img.gz | grep firmware | awk '{ print $2 }'`
mdsz=`gunzip -l media.img.gz | grep media | awk '{ print $2 }'`
echo $fwsz
echo $mdsz
rm *
cd ..
rmdir temp
if [ $fwsz -ge $fwpart ]
then
   echo "FW size exceeds partition size"
   echo -n "error" > $DOWNLOAD_PATH/$BLOB_VERSION/status
   exit 2
fi
if [ $mdsz -ge $mdpart ]
then
   echo "Media size exceeds partition size"
   echo -n "error" > $DOWNLOAD_PATH/$BLOB_VERSION/status
   exit 3
fi
swupdate -i $DOWNLOAD_PATH/$BLOB_VERSION/update.swu -H ew8:1.0

if [ $? -ne 0 ]
then
   echo "General error in swupdate"
   echo -n "error" > $DOWNLOAD_PATH/$BLOB_VERSION/status
   exit 1
fi
