DESCRIPTION = "Init script for baby application"
SRC_URI = "file://canquicksvc"
SRC_URI += "file://qtprofile.sh"
LICENSE = "CLOSED"
PR = "r0"

do_install_append() {
    install -d ${D}${sysconfdir}/profile.d/
    install -m 0755 ${WORKDIR}/qtprofile.sh ${D}${sysconfdir}/profile.d/
}

do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/canquicksvc ${D}${sysconfdir}/init.d/canquicksvc
}

inherit update-rc.d allarch

INITSCRIPT_NAME = "canquicksvc"
INITSCRIPT_PARAMS = "start 05 S 2 . stop 19 0 1 6 ."
