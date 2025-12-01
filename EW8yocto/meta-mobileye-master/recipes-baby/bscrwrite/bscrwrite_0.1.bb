#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Mobileye baby switch to ROMBoot"
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase qtquick1"

#take project from local development folder
SRC_URI = "file://bscrwrite-0.1.tar.xz"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/bscrwrite/bin/* \
  "


do_install() {
  make INSTALL_ROOT=${D} install
	install -m 0755 ${B}/bscrwrite ${D}/opt/bscrwrite/bin/
}



