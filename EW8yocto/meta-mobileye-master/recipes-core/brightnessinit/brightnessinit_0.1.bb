AUTHOR = "Nochum Linczewski <nochum.linczewski@mobileye.com>"
SUMMARY = "Init script for light sensor control application"
SRC_URI = "file://lightctl"
LICENSE = "CLOSED"
PR = "r0"



do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/lightctl ${D}${sysconfdir}/init.d/brightnessinit
}

inherit update-rc.d allarch

INITSCRIPT_NAME = "brightnessinit"
INITSCRIPT_PARAMS = "start 04 S 2 . stop 19 0 1 6 ."
