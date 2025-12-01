ROOTFS_POSTPROCESS_COMMAND += " \
myrootfs_version2epoch ; \
myrootfs_reproducible_version2epoch ; \
"

myrootfs_version2epoch[vardepsexclude] = "BUILDNAME"

myrootfs_version2epoch() {
	if [ "${BUILDNAME}" != "" ]; then
     year=$(echo ${BUILDNAME}|cut -c1-4)
     month=$(echo ${BUILDNAME}|cut -c5-6)
     day=$(echo ${BUILDNAME}|cut -c7-8)
     hour=$(echo ${BUILDNAME}|cut -c9-10)
     minute=$(echo ${BUILDNAME}|cut -c11-12)
     second=$(echo ${BUILDNAME}|cut -c13-14)
     tstmp=$(date -d "${year}-${month}-${day} ${hour}:${minute}:${second} UTC" +%s)
     printf "%8x\n" ${tstmp} > ${IMAGE_ROOTFS}/etc/version2epoch
  fi
}

myrootfs_reproducible_version2epoch() {
	if [ "${REPRODUCIBLE_TIMESTAMP_ROOTFS}" != "" ]; then
		printf "%8x" ${REPRODUCIBLE_TIMESTAMP_ROOTFS} > ${IMAGE_ROOTFS}/etc/version2epoch
  fi
}
