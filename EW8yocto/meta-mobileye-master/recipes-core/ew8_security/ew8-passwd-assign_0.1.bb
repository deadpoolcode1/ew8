#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Generates passwd for EW8."
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase openssl"

#take project from local development folder
SRC_URI = "file://serialnumber.tar.xz"


S = "${WORKDIR}"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/serialnumber/* \
  /opt/serialnumber/bin/* \
  "


do_install() {
  make INSTALL_ROOT=${D} install
  install -d ${D}/opt/serialnumber/
	install -m 0755 ${B}/serialnumber ${D}/opt/serialnumber/bin/
}

pkg_postinst_${PN}() {
    export EW8_ROOT_PASSWORD="$(/opt/serialnumber/bin/serialnumber | /usr/bin/sha256sum | cut -c 10-17)"
    /usr/sbin/usermod -p $(openssl passwd ${EW8_ROOT_PASSWORD}) root
    unset EW8_ROOT_PASSWORD
    echo EW8 Mobileye Root password initialized. > /dev/ttyS0
}
