require recipes-graphics/ttf-fonts/ttf.inc

SUMMARY = "HindSiliguri font - TTF Version"
#HOMEPAGE = "http://www.levien.com/type/myfonts/inconsolata.html"
LICENSE = "OFL-1.1"
LIC_FILES_CHKSUM = "file://OFL.txt;md5=d391df291ae9c6de6030dc9cdf7953bf"
PR = "r0"

PACKAGES = "${PN} ${PN}-dbg"

SRC_URI = "file://${PN}.tar.xz"

S = "${WORKDIR}"

FILES_${PN} = "${datadir}/fonts/truetype/HindSiliguri-*.ttf \
    ${datadir}/doc/${PN}/*"

do_configure() {
}
#    mv ${WORKDIR}/HindSiliguri-*.ttf ${S}/

do_install_append() {
    install -d ${D}${datadir}/doc/${PN}/
    install -m 0644 ${WORKDIR}/OFL.txt ${D}${datadir}/doc/${PN}/
}

#SRC_URI[md5sum] = "0fbe014c1f0fb5e3c71140ff0dc63edf"
#SRC_URI[sha256sum] = "1561e616c414a1b82d6e6dfbd18e5726fd65028913ade191e5fa38b6ec375a1a"
