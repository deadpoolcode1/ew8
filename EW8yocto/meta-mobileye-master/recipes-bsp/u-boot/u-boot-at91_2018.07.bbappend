FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += "lz4-native"

SRC_URI += "file://at91-sama5d2_baby.dts;subdir=git/arch/arm/dts"
SRC_URI += "file://sama5d2_baby_defconfig;subdir=git/configs"

COMPATIBLE_MACHINE = "sama5d2-baby"
