SRC_URI += "file://update.sh"
SRC_URI += "file://sw-description.all"
SRC_URI += "file://sw-description.media"
SRC_URI += "file://sw-description.firmware"
SRC_URI += "file://swupack.sh"
SRC_URI += "file://swumerge.sh"

# BBCLASSEXTEND = "native nativesdk"

DEPENDS += " coreutils-native e2fsprogs-native util-linux-native pseudo-native "

# do_swupdate[vardepsexclude] = "WKS_FULL_PATH WKS_FILES TOPDIR"

do_swupdates_delivery() {
  # pack
  export PSEUDO_LIBDIR=${PSEUDO_LIBDIR}64

  DELIVERY=$(date -u +%Y%m%d%H%M%S)

  cp ${WORKDIR}/update.sh .
  cp ${WORKDIR}/sw-description* .
  mkdir -p ${TMPDIR}/deploy/swu/

  ${WORKDIR}/swupack.sh -f ${PKGDEST}/${PN}/opt/canquick/bin/ -o ${PN}-${PV}.fw.${DELIVERY}.swu -d

  ${WORKDIR}/swupack.sh -m ${PKGDEST}/${PN}/opt/canquick/ -o ${PN}-${PV}.media.${DELIVERY}.swu -d

  ${WORKDIR}/swumerge.sh -f ${PN}-${PV}.fw.${DELIVERY}.swu -m ${PN}-${PV}.media.${DELIVERY}.swu -o ${PN}-${PV}.all.${DELIVERY}.swu -d
  # mkdir -p ${TMPDIR}/deploy/swu/
   mv *.swu ${TMPDIR}/deploy/swu/
}

do_package_qa_append() {
    bb.build.exec_func("do_swupdates_delivery", d)
}
