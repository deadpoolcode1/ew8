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

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase qtquick1 libsocketcan qrencode qtimageformats ttf-hind-siliguri"

#take project from local development folder
SRC_URI = "file://canquick.tar.xz"

require canquick-swupdate.inc

S = "${WORKDIR}"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/canquick/bin/* \
  /opt/canquick/qml/images/* \
  /opt/canquick/qml/fonts/* \
  /opt/canquick/signals/* \
  /opt/canquick/configs/* \
  /opt/canquick/dbc/* \
  /opt/canquick/qml/* \
  "


do_install() {
  make INSTALL_ROOT=${D} install
  rm ${D}/opt/canquick/qml/images/*/*.svg
  rm ${D}/opt/canquick/qml/images/*/*/*.svg
	install -m 0755 ${B}/canquick ${D}/opt/canquick/bin/
}



