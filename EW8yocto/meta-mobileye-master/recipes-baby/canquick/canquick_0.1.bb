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

DEPENDS = "qtbase qtquick1 libsocketcan qrencode qtimageformats"

#take project from local git repository:
SRC_URI = "git://git@gitlab.mobileye.com/ims-sw-tools/embedded/canquick.git;protocol=ssh;branch=dev;rev=74bcbc0395177e82440e68941113b3e6ce2414c0;"

#SRC_URI += "file://modify_version_x.x.1.diff"
#SRC_URI += "file://modify_version_x.x.2.diff"
#SRC_URI += "file://modify_version_x.x.3.diff"


require canquick-swupdate.inc

S = "${WORKDIR}/git"

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



