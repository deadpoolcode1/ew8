#FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
#SRC_URI += "file://atmel-color-format-force.patch \
#            file://0001-make-QGraphicsItem-update-virtual.patch \
#            file://0003-Add-support-for-specifying-DRM-dumb-buffer-pixel-for.patch \
#            file://0004-Provide-access-to-linuxfb-dri-fd-through-platform.patch \
#            file://0005-Support-DRM-KMS-planes-in-linuxfb-DRM-backend.patch "

# qtwebkit will fail later in the build if icu is not enabled. As Poky does not
# enable it, do it here. This should be removed when the reverse dependency is
# added.
PACKAGECONFIG_append = " gif "
