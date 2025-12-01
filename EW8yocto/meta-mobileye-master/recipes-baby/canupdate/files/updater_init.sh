#!/bin/bash

#set -x
SCRIPT_DIR="/opt/updater/scripts"
# $(dirname "$(readlink -f "$0")")


# Load updater_environmet support rutines
#   read_env_variables
#   write_env_variables
#   Environment variables are:
#       fw_partition_index
#       media_partition_index
#       rollback_restart_count
#       rollback_status
#       update_status
source $SCRIPT_DIR/updater_environment.sh

# Global variables 
MAX_FAILED_BOOT_ATTEMTS=2
#FIRMWARE_PARTITION_MOUNT="/opt/canquick/bin"
#MEDIA_PARTITION_MOUNT="/opt/canquick"


# called from canquick app if the app start is normal
# clear rollback count
update_successfull_boot()
{
  # Read mirrored environment file and set coressponding environemt variables
  read_env_variables

  rollback_restart_count=0
  rollback_status="none"
  update_status="none"

  # Write environemt variables to mirrored md5 shilded storage
  write_env_variables
}


# check updfate status on boot and changes properly drive mounts
#no parameters
#returns 1 if partitions are changed and rollback counter is initialized, 0 otherwise
complete_previous_update()
{
    if [[ "$update_status" == "all" ]]; then
      fw_partition_index=`swap_fw_partition_index $fw_partition_index`
      media_partition_index=`swap_media_partition_index $media_partition_index`
    elif [[ "$update_status" == "media" ]]; then
        media_partition_index=`swap_media_partition_index $media_partition_index`
    else #firmware
        fw_partition_index=`swap_fw_partition_index $fw_partition_index`
    fi
    rollback_status=$update_status
    update_status="none"
    rollback_restart_count=0
}

# rollback updates partitions back as the update was failed
# return 1 on rollback, 0 on no need in rollback
perform_update_rollback()
{
  if [[ "$rollback_status" == "all" ]]; then
    fw_partition_index=`swap_fw_partition_index $fw_partition_index`
    media_partition_index=`swap_media_partition_index $media_partition_index`
  elif [[ "$rollback_status" == "media" ]]; then
      media_partition_index=`swap_media_partition_index $media_partition_index`
  else #firmware
      fw_partition_index=`swap_fw_partition_index $fw_partition_index`
  fi
  rollback_status="none"
  rollback_restart_count=0
}

#mount firmware and media partitions
mount_partitions()
{
  # get partition base indexes according to .wic file

  #mkdir -p $MEDIA_PARTITION_MOUNT
  mount $DEVICE_NAME$media_partition_index #$MEDIA_PARTITION_MOUNT

  #mkdir -p $FIRMWARE_PARTITION_MOUNT
  mount $DEVICE_NAME$fw_partition_index #$FIRMWARE_PARTITION_MOUNT
}

watchdog_monitor()
{
	sleep 30
  read_env_variables
	if [[ $rollback_status == "none" ]]; then
	   echo "Succesfull boot, disarm watchdog"
	else
	   echo "Watchdog fired, reboot"
	   /sbin/shutdown -r now
	fi
}


reset_main_application_cache()
{
  CANQUICK_CACHE_FILE="/home/root/config.dat"

  if [ -f "${CANQUICK_CACHE_FILE}" ]
  then
    echo "Removing Canquick Application cache."
    rm -f "${CANQUICK_CACHE_FILE}"
  fi

}

swupdate_mount_partitions()
{
   # Read mirrored environment file and set coressponding environemt variables
  read_env_variables

  # check if this is the first boot and the firmware and media partitions are empty
  # in such a case copy the default firmware and media files to the partitions

  # NOTE: Default partitions are populated at the production time (Lincz)
  # check_first_boot

  #check if rollback is needed

  do_reset_cache=false

  if [[ "$rollback_status" != "none" ]]; then
    if [[ $rollback_restart_count < $MAX_FAILED_BOOT_ATTEMTS ]]; then
        rollback_restart_count=$((rollback_restart_count+1))
    else
        perform_update_rollback
        do_reset_cache=true
    fi
    # write environemt variables to mirrored md5 shilded storage
    write_env_variables
  fi

  # check if the update is pending for partition swap on reset
  if [[ "$update_status" != "none" ]]; then
    complete_previous_update
    do_reset_cache=true
    # write environemt variables to mirrored md5 shilded storage
    write_env_variables
  fi

  # mount partitions at this point and continue firmware boot
  mount_partitions

  if ${do_reset_cache}; then
    reset_main_application_cache
  fi

  # Start watchdog to monitor corrupted firmware
  watchdog_monitor &
}


