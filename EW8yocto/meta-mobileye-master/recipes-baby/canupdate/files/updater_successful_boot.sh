#!/bin/bash

#set -x
SCRIPT_DIR="/opt/updater/scripts"


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

# called from canquick/canupdater app if the app start is normal
# clear rollback count

# Read mirrored environment file and set coressponding environemt variables
read_env_variables

rollback_restart_count=0
rollback_status="none"
update_status="none"

# Write environmet variables to mirrored md5 shilded storage
write_env_variables

readonly SPLASHNAME="me_splash_320x240.raw.lz4"
readonly SRCSPLASHFOLDER="/opt/canquick/qml/images/logo"
readonly TARGETSPLASHFOLDER="/home/root"

do_replace_splash() {
   echo replacing the splash
   cp  "${SRCSPLASHFOLDER}/${SPLASHNAME}" "${TARGETSPLASHFOLDER}/${SPLASHNAME}"
   sync
}


if test -f "${SRCSPLASHFOLDER}/${SPLASHNAME}"
then
	if test ! -f ${TARGETSPLASHFOLDER}/${SPLASHNAME} 
	then
		do_replace_splash
#        elif test -n "$(cmp ${SRCSPLASHFOLDER}/${SPLASHNAME} ${TARGETSPLASHFOLDER}/${SPLASHNAME})"
        elif ! $(cmp -s "${SRCSPLASHFOLDER}/${SPLASHNAME}" "${TARGETSPLASHFOLDER}/${SPLASHNAME}")
	then
                do_replace_splash
	fi
fi



