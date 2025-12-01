SUMMARY = "Replacement recipe"
FILESEXTRAPATHS_prepend := "${THISDIR}/init-ifupdown-1.0:"
SRC_URI += "file://interfaces"

#CONFFILES_${PN} = "${sysconfdir}/network/interfaces"

do_install_append() {
  install -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/interfaces
}

