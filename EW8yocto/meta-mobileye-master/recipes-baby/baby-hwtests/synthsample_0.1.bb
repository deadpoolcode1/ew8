#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Synthesizer sample sound play"
HOMEPAGE = "https://mobileye.com"
LICENSE = "CLOSED"
PRIORITY = "optional"
PR = "r0"

PACKAGES = "${PN} ${PN}-dbg"

DEPENDS = "qtbase"

#SRCREV="${AUTOREV}"

#take project from local git repository:
SRC_URI = "git:///homes/nochum/synthsample/.git;protocol=file;rev=9289388549ac25a47a5a8dde028993bf20dcaf5a"

S = "${WORKDIR}/git"

inherit qmake5 pkgconfig

FILES_${PN} = " \
  /opt/synthsample/bin/* \
  "


do_install() {
  make INSTALL_ROOT=${D} install
	install -m 0755 ${B}/synthsample ${D}/opt/synthsample/bin/
}



