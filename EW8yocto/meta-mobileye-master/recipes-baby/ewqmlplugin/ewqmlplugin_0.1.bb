#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "A Qt-plugin for Mobileye canquick application"
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase qtquick1"

#take project from local git repository:
SRC_URI = "git:///mobileye/repository/git/aftermarket/canquick.git;protocol=file;rev=4a33f674b3923de8cbc4a8a8f8722a652f520136"

S = "${WORKDIR}/git/plugins/${PN}"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  ${libdir}/qt5/qml/com/mobileye/lib${PN}.so \
  ${libdir}/qt5/qml/com/mobileye/qmldir \
  "

do_install() {
	mkdir -p ${D}${libdir}/qt5/qml/com/mobileye
	install -m 0755 ${B}/lib${PN}.so ${D}${libdir}/qt5/qml/com/mobileye/lib${PN}.so
	install -m 0755 ${B}/qmldir ${D}${libdir}/qt5/qml/com/mobileye/qmldir
}



