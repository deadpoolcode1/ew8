#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Mobileye canquick application"
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase qtquick1 libsocketcan"

#take project from local git repository:
#SRC_URI = "file://canupdate-0.1.tar.gz"
SRC_URI = "git://git@gitlab.mobileye.com/ims-sw-tools/embedded/canupdate.git;protocol=ssh;branch=IMS-11033_CAN_BDR_json_config;rev=931a551ceba43a34388587683a3e1ee0fbc3251c;"
QMAKE_PROFILES = "${S}/git/canupdate.pro"

S = "${WORKDIR}"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/canupdate/bin/* \
  "


do_install() {
  make INSTALL_ROOT=${D} install
  install -d ${D}/opt/canupdate/bin/
	install -m 0755 ${B}/canupdate ${D}/opt/canupdate/bin/
}



