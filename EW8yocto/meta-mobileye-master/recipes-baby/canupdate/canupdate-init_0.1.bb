DESCRIPTION = "Init script for canupdate application"
SRC_URI = "file://canupdatesvc"
LICENSE = "CLOSED"
PR = "r0"

SRC_URI += "file://updater_environment.sh"
SRC_URI += "file://updater_init.sh"
SRC_URI += "file://updater_run.sh"
SRC_URI += "file://updater_init.sh"
SRC_URI += "file://updater_successful_boot.sh"
SRC_URI += "file://fw_env.config"


do_install() {
	install -d ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/canupdatesvc ${D}${sysconfdir}/init.d/canupdatesvc
	install -d ${D}/opt/updater/
	install -d ${D}/opt/updater/download
	install -d ${D}/opt/updater/environment
	install -d ${D}/opt/updater/scripts
	install -m 0755 ${WORKDIR}/updater_environment.sh ${D}/opt/updater/scripts/updater_environment.sh
	install -m 0755 ${WORKDIR}/updater_init.sh ${D}/opt/updater/scripts/updater_init.sh
	install -m 0755 ${WORKDIR}/updater_run.sh ${D}/opt/updater/scripts/updater_run.sh
	install -m 0755 ${WORKDIR}/updater_successful_boot.sh ${D}/opt/updater/scripts/updater_successful_boot.sh
	install -m 0644 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}

FILES_${PN} += " \
  /opt/updater/scripts/* \
  /opt/updater/environment \
  /opt/updater/download \
"

inherit update-rc.d allarch
RDEPENDS_${PN} += "bash"

INITSCRIPT_NAME = "canupdatesvc"
INITSCRIPT_PARAMS = "start 04 S 2 . stop 19 0 1 6 ."
