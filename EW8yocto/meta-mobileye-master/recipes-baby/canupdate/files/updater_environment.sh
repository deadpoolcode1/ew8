#!/bin/bash

#set +x

#Global varibales
PRI=".pri"
SEC=".sec"
UPDATER_ENV_FILE="/opt/updater/environment/updater_env"
DEVICE_NAME="/dev/mmcblk0p"
# Warning: the partition indexes below should correspond to .wic file layout from Yocto
FIRMWARE_PARTITION_BASE_INDEX=5
MEDIA_PARTITION_BASE_INDEX=3
# Cached environment file name for internal environmet operations
CACHED_ENV_FILE_NAME=$(mktemp -p /var/volatile)

# Environment variables set to defaults
fw_partition_index=$FIRMWARE_PARTITION_BASE_INDEX
media_partition_index=$MEDIA_PARTITION_BASE_INDEX
rollback_restart_count=0
rollback_status="none"
update_status="none"

#get md5 sum from md5sum command output
#parameters $1: file name
get_md5()
{
  local file_name=$1
  local md5=`md5sum ${file_name} | awk '{ print $1 }'`
  echo "$md5"
}

# propagates partition indices forth and back
#parameters: 1:partition index, 6 or 7
#returns: new index, 7 or 6
swap_media_partition_index()
{
  if [[ "$1" == "3" ]]; then
    echo "6"
  else
    echo "3";
  fi
}

# propagates partition indices forth and back
#parameters: 1:partition index, 3 or 5
#returns: new index, 5 or 3
swap_fw_partition_index()
{
  if [[ "$1" == "5" ]]; then
    echo "7"
  else
    echo "5";
  fi
}


# init default environemt file
init_default_env_file()
{
cat << EOF > $CACHED_ENV_FILE_NAME
fw_partition_index=$fw_partition_index
media_partition_index=$media_partition_index
rollback_restart_count=$rollback_restart_count
rollback_status=$rollback_status
update_status=$update_status
EOF
}

print_env()
{
  echo  "reading rollback_restart_count=$rollback_restart_count"
  echo  "reading fw_partition_index=$fw_partition_index"
  echo  "reading media_partition_index=$media_partition_index"
  echo  "reading update_status=$update_status"
  echo  "reading rollback_status=$rollback_status"
}
# read environment parameter from cached environemt
read_env_param()
{
  local  param_key=$1
  local  param_value=`grep "$param_key=" $CACHED_ENV_FILE_NAME | sed -e 's/.*=//'`
  echo "$param_value"
}

# write environment parameter to cached environmet
write_env_param()
{
  local  param_key=$1
  local  param_value=$2
  sed -i "/^$param_key/s/=.*$/=$param_value/" $CACHED_ENV_FILE_NAME
}

# Write mirrored environment file from the cached copy
#parameters $1:environemnt file name
write_env_file()
{
   local  env_file_name=$1
   local  file_md5=""

   cp -a $CACHED_ENV_FILE_NAME  $env_file_name$PRI
   file_md5=`get_md5 $env_file_name$PRI`
   echo $file_md5 > $env_file_name$PRI.md5
   sync

   cp -a $CACHED_ENV_FILE_NAME  $env_file_name$SEC
   file_md5=`get_md5 $env_file_name$SEC`
   echo $file_md5 > $env_file_name$SEC.md5
   sync
}

# Checks environemt consistensy and reads file to cached environmet file
#parameters: $1:environemnt file name
read_env_file()
{
  local env_file_name=$1

  if [ ! -f "$env_file_name$PRI" ]; then
    init_default_env_file
    write_env_file $UPDATER_ENV_FILE
  fi

  local md5_calc_pri=`get_md5 $env_file_name$PRI`
  local md5_calc_sec=`get_md5 $env_file_name$SEC`
  local md5_file_pri=`cat $env_file_name$PRI.md5`
  local md5_file_sec=`cat $env_file_name$SEC.md5`

   if [ "$md5_calc_pri" = "$md5_file_pri" ]; then
     cp -a $env_file_name$PRI $CACHED_ENV_FILE_NAME
   elif [ "$md5_calc_sec" = "$md5_file_sec" ]; then
     cp -a $env_file_name$SEC $CACHED_ENV_FILE_NAME
   else
      init_default_env_file
   fi
}

read_env_variables()
{
  read_env_file $UPDATER_ENV_FILE

  update_status=`read_env_param "update_status"`
  fw_partition_index=`read_env_param "fw_partition_index"`
  media_partition_index=`read_env_param "media_partition_index"`
  rollback_status=`read_env_param "rollback_status"`
  rollback_restart_count=`read_env_param "rollback_restart_count"`
}

write_env_variables()
{
  write_env_param "update_status" $update_status
  write_env_param "fw_partition_index" $fw_partition_index
  write_env_param "media_partition_index" $media_partition_index
  write_env_param "rollback_status" $rollback_status
  write_env_param "rollback_restart_count" $rollback_restart_count

  write_env_file $UPDATER_ENV_FILE
}

