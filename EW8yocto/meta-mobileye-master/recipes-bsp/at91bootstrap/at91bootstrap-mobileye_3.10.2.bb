require recipes-bsp/at91bootstrap/at91bootstrap.inc

LIC_FILES_CHKSUM = "file://main.c;endline=27;md5=a2a70db58191379e2550cbed95449fbd"

COMPATIBLE_MACHINE = "sama5d2-baby"
SRC_URI = "git://git@gitlab.mobileye.com:ims-sw-tools/embedded/at91bootstrap.git;branch=mobileye-v3.10.2;protocol=file"
PV = "3.10.2+git${SRCPV}"
SRCREV = "37109e389f656017384617127d074b26912a7817"

SRC_URI += "file://defconfig"


S = "${WORKDIR}/git"

do_configure_prepend() {
  # Prefer local defconfig file over one in hte source tree:
	if [ -f "${WORKDIR}/defconfig" ] && [ ! -f "${B}/.config" ]; then
		cp "${WORKDIR}/defconfig" "${B}/.config"
	fi

	if [ -f "${S}/commercial/board/mobileye/${AT91BOOTSTRAP_MACHINE}/${AT91BOOTSTRAP_TARGET}" ] && [ ! -f "${B}/.config" ]; then
		cp "${S}/commercial/board/mobileye/${AT91BOOTSTRAP_MACHINE}/${AT91BOOTSTRAP_TARGET}" "${B}/.config"
	fi
}
