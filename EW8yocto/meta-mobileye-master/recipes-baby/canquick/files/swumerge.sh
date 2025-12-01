#!/bin/bash

set -e
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
WORK_DIR=$(pwd)


# Common defines
readonly FIRMWARE_IMAGE_TYPE="firmware"
readonly MEDIA_IMAGE_TYPE="media"
readonly FW_PARTITION_SIZE="32M"
readonly MEDIA_PARTITION_SIZE="32M"

OUTPUT_FILE_NAME="update.swu"

# params:
# $1 - folder
# $2 - type

if [ $# -eq 0 ]; then
    echo "Usage: swupack.sh -f <fw_pack> -m <media_pack> [-o <merged_pack_name>]"
    exit 1
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--fw)
    FW_SWUPACK=$2
    shift # past argument
    shift # past value
    ;;
    -m|--media)
    MEDIA_SWUPACK=$2
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

if [[ ! -z "$FW_SWUPACK" ]] && [[ ! -z "$MEDIA_SWUPACK" ]]; then
  TMPDIR=$(mktemp -d)
  cd ${TMPDIR}
  cpio -iv ${FIRMWARE_IMAGE_TYPE}.img.gz < ${WORK_DIR}/${FW_SWUPACK}
  cpio -iv ${MEDIA_IMAGE_TYPE}.img.gz < ${WORK_DIR}/${MEDIA_SWUPACK}
  touch arch_all
  FILES="${FILES} ${FIRMWARE_IMAGE_TYPE}.img.gz ${MEDIA_IMAGE_TYPE}.img.gz"
  FILES="${FILES} arch_all"
  cp -a ${SCRIPT_DIR}/sw-description.all ${TMPDIR}/sw-description
  cp -a ${SCRIPT_DIR}/update.sh ${TMPDIR}/
else
  echo error: faulty sources names
  exit 1
fi

echo "Pack final .swu file"
for i in $FILES;do
    echo $i ;done | cpio -ov -H crc >  ${WORK_DIR}/${OUTPUT_FILE_NAME}

cd ${WORK_DIR}
rm -r ${TMPDIR}
echo "Done"

