#
# This file was derived from the 'Hello World!' example recipe in the
# Yocto Project Development Manual.
#
AUTHOR = "Andreas Heitmann <andreas.heitmann@gmail.com>"
SUMMARY = "Access and convert ASC, BLF, DBC, and MDF files"
HOMEPAGE = "https://cantools.sourceforge.io/"
LICENSE = "GPLv3"
PRIORITY = "optional"
SECTION = "LIBS"
PR = "r0"

inherit autotools pkgconfig

EXTRA_OECONF = "--bindir=${bindir}/${PN}"

#RDEPENDS_${PN} = " zlib hdf5 matio glib-2.0 libcheck "
DEPENDS = " zlib hdf5 matio glib-2.0 libcheck "

#LIC_FILES_CHKSUM = "file://COPYING;md5=02cdf1821aecbae99f76cff331b71285"
LIC_FILES_CHKSUM = "file://COPYING;md5=3c34afdc3adf82d2448f12715a255122"

SRC_URI = "https://sourceforge.net/projects/cantools/files/cantools-src/0.24/cantools-0.24.tar.gz"

SRC_URI[md5sum] = "bf426835ca9a5eb2b947d35420d574b8"

BBCLASSEXTEND = "native nativesdk"



