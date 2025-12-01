FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS += "lz4-native"

COMPATIBLE_MACHINE = "sama5d2-baby"

SRC_URI += "file://at91-sama5d2_baby.dts;subdir=git/arch/arm/boot/dts"
SRC_URI += "file://at91-sama5d2_baby_pcb353.dts;subdir=git/arch/arm/boot/dts"
SRC_URI += "file://at91-sama5d2_baby_pcb000928.dts;subdir=git/arch/arm/boot/dts"
SRC_URI += "file://at91-sama5d2_baby_synth.dts;subdir=git/arch/arm/boot/dts"
SRC_URI += "file://panel-sitronix-st7789v-mobileye-baby.diff"
SRC_URI += "file://panel-simple-mobileye-baby.diff"
SRC_URI += "file://pinctrl-at91-pio4-mobileye-initcall-fix.diff"
SRC_URI += "file://defconfig"

