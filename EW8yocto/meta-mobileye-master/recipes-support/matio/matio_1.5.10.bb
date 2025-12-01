#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
SUMMARY = "MAT-File IO library for LabVIEW"
HOMEPAGE = "http://matio-labview.sourceforge.net/"
LICENSE = "BSD"
PRIORITY = "optional"
SECTION = "LIBS"
PR = "r0"

inherit autotools

RDEPENDS_${PN} = "zlib hdf5"

LIC_FILES_CHKSUM = "file://COPYING;md5=02cdf1821aecbae99f76cff331b71285"

SRC_URI = "http://downloads.sourceforge.net/matio/matio-1.5.10.tar.gz"

SRC_URI[sha256sum] = "41209918cebd8cc87a4aa815fed553610911be558f027aee54af8b599c78b501"

EXTRA_OEMAKE = "\
                'CFLAGS=-DZ_PREFIX'\
                "

