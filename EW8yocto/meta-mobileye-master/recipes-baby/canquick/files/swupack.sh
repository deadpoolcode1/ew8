#!/bin/bash

set -e
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Common defines
OUTPUT_FILE_NAME="update.swu"
FIRMWARE_IMAGE_TYPE="firmware"
MEDIA_IMAGE_TYPE="media"
FW_PARTITION_SIZE="36M"
MEDIA_PARTITION_SIZE="36M"


create_image_file_yocto()
{
  local input_folder=$1
  local image_type=$2
  local output_file=$2.img.gz
  local tmp_file=$(mktemp)
  local tmp_dir=$(mktemp -d)
  local partition_size
  local partition_type

  echo "Prepare from folder $1, of type $2, image file $3"
  if [ $image_type == "firmware" ]; then
    partition_size=$FW_PARTITION_SIZE
    partition_type="FW_PARTITION"
  else
    partition_size=$MEDIA_PARTITION_SIZE
    partition_type="MEDIA_PARTITION"
  fi

  cp -a $input_folder/* $tmp_dir
  if [ -d $tmp_dir/bin ]
  then
    rm -r $tmp_dir/bin/*
  fi
  sync

  fstype=ext4

  truncate -s $partition_size $tmp_file
	mkfs.$fstype  ${tmp_file} -d $tmp_dir
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.$fstype -pvfD ${tmp_file} || [ $? -le 3 ]

  #e2fsck -f $tmp_file
  #resize2fs -M $tmp_file

  # TODO try xz compression
  gzip $tmp_file
  mv $tmp_file.gz $output_file

  echo "Add $output_file to SWUpdate archive"
  # add to output file list (global variable)
  FILES="$FILES $output_file"
  return 0
}

# params:
# $1 - folder
# $2 - type
create_image_file()
{
  local input_folder=$1
  local image_type=$2
  local output_file=$2.img.gz
  local tmp_file=$(mktemp)
  local tmp_dir=$(mktemp -d)
  local partition_size
  local partition_type

  echo "Prepare from folder $1, of type $2, image file $3"
  if [ $image_type == "firmware" ]; then
    partition_size=$FW_PARTITION_SIZE
    partition_type="FW_PARTITION"
  else
    partition_size=$MEDIA_PARTITION_SIZE
    partition_type="MEDIA_PARTITION"
  fi
  truncate -s $partition_size $tmp_file
  mkfs.ext4 $tmp_file 1>/dev/null 2>&1
  mount -o loop $tmp_file $tmp_dir
  cp -a $input_folder/* $tmp_dir
  if [ -d $tmp_dir/bin ]
  then
    rm -r $tmp_dir/bin
  fi
  sync
  umount $tmp_dir

  #e2fsck -f $tmp_file
  #resize2fs -M $tmp_file

  gzip $tmp_file
  mv $tmp_file.gz $output_file

  echo "Add $output_file to SWUpdate archive"
  # add to output file list (global variable)
  FILES="$FILES $output_file"
  return 0
}

if [ $# -eq 0 ]; then
    echo "Usage: swupack.sh -f <fw_folder> -m <media_folder> -o <output_file>"
    exit 1
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--fw)
    FW_FOLDER=$2
    shift # past argument
    shift # past value
    ;;
    -m|--media)
    MEDIA_FOLDER=$2
    shift # past argument
    shift # past value
    ;;
    -o|--output)
    OUTPUT_FILE_NAME=$2
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    set -x
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

FILES="sw-description update.sh"

if [[ ! -z "$FW_FOLDER" ]] && [[ ! -z "$MEDIA_FOLDER" ]]; then
  create_image_file_yocto $FW_FOLDER $FIRMWARE_IMAGE_TYPE
  create_image_file_yocto $MEDIA_FOLDER $MEDIA_IMAGE_TYPE
  touch arch_all
  FILES="$FILES arch_all"
  cp -a sw-description.all sw-description

else
# use proper sw-description file for each update type
if [ ! -z "$FW_FOLDER" ]; then
  create_image_file_yocto $FW_FOLDER $FIRMWARE_IMAGE_TYPE
  cp -a sw-description.$FIRMWARE_IMAGE_TYPE sw-description
  touch arch_$FIRMWARE_IMAGE_TYPE
  FILES="$FILES arch_$FIRMWARE_IMAGE_TYPE"

else
if [ ! -z "$MEDIA_FOLDER" ]; then
  create_image_file_yocto $MEDIA_FOLDER $MEDIA_IMAGE_TYPE
  cp -a sw-description.$MEDIA_IMAGE_TYPE sw-description
  touch arch_$MEDIA_IMAGE_TYPE
  FILES="$FILES arch_$MEDIA_IMAGE_TYPE"
fi
fi
fi


echo "Pack final .swu file"
for i in $FILES;do
    echo $i ;done | cpio -ov -H crc >  ${OUTPUT_FILE_NAME}

echo "clean work dir"
rm -f *.img.gz
rm -f *.img.xz
rm -f sw-description

echo "Done"

