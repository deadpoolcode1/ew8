#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Mobileye EW8 splash via idle drm panel"
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase libdrm"

#take project from local development folder
SRC_URI = "file://ew8_splash.tar.xz"
SRC_URI += "file://me_splash_320x240.raw.lz4"


S = "${WORKDIR}"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/ew8_splash/* \
  /opt/ew8_splash/bin/* \
  /home/root/*.raw.lz4 \
  "


do_install() {
  make INSTALL_ROOT=${D} install
  install -d ${D}${base_prefix}/home/root/
  install -d ${D}/opt/ew8_splash/
	install -m 0755 ${B}/ew8_splash ${D}/opt/ew8_splash/bin/
	install -m 0755 ${WORKDIR}/me_splash_320x240.raw.lz4 ${D}${base_prefix}/home/root/me_splash_320x240.raw.lz4
}



