#!/bin/sh

if [ $# -lt 1 ]; then
    exit 0;
fi

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
UPDATER_SCRIPT_DIR="/opt/updater/scripts"
#UPDATER_SCRIPT_DIR=$SCRIPT_DIR"/opt/updater/scripts"

# Load updater_environmet support rutines
#   read_env_variables
#   write_env_variables
#   Environment variables are:
#       fw_partition_index
#       media_partition_index
#       rollback_restart_count
#       rollback_status
#       update_status
source $UPDATER_SCRIPT_DIR/updater_environment.sh

echo "Update script --- " $1 "phase"
# Read mirrored environment file and set coressponding environemt variables
read_env_variables

if [[ $1 == "preinst" ]]; then

    # find the new partion indexes by swapping the current one
    new_fw_partition_index=`swap_fw_partition_index $fw_partition_index`
    new_media_partition_index=`swap_media_partition_index $media_partition_index`

    echo "presinst: re-mount /dev/fwupdate and /dev/mediaupdate"
    # Create symbolic links to the partitions suitable for update
    # Here we implement update A/B alternating scheme
    # ln -sf will create symbolic link and oveerride existing file
    ln -sf $DEVICE_NAME$new_fw_partition_index /dev/fwupdate
    ln -sf $DEVICE_NAME$new_media_partition_index /dev/mediaupdate
    exit 0
fi

if [ $1 = "postinst" ]; then

    swu_file_name=`ls *.swu`
    update_image_type_file=`cpio -t <"$swu_file_name" | grep arch_`
    update_image_type=`echo "$update_image_type_file" | cut -c6-`

    update_status=$update_image_type
    # Write mirrored environment file with new value.
    # Actual partition switch will happen on reboot, see init.sh
    rollback_status_count=0
    rollback_status="none"
    write_env_variables
    echo "postinst: environmet: update_status=$update_status"
    DOWNLOAD_PATH="/opt/updater/download"
    VERSION_FILE="$DOWNLOAD_PATH"/"_version"

    BLOB_VERSION=`cat $VERSION_FILE`
    echo "done" >"$DOWNLOAD_PATH/$BLOB_VERSION/status"

fi
