DESCRIPTION = "An image that will launch into the demo application for the embedded (not based on X11) version of Qt."
LICENSE = "CLOSED"
PR = "r0"

DISTRO_FEATURES_remove = " nfs wifi "
IMAGE_INSTALL_remove = " nfs-utils avahi-daemon "

IMAGE_FEATURES += "ssh-server-openssh package-management"

IMAGE_INSTALL += "\
	packagegroup-core-boot \
	${CORE_IMAGE_EXTRA_INSTALL} \
	packagegroup-base-usbgadget \
	openssh-sftp-server \
	kernel-modules \
	setserial \
	opkg \
	iperf3 \
	\
	nbench-byte \
	lmbench \
	i2c-tools \
	devmem2 \
	dosfstools \
	libdrm-tests \
	mtd-utils \
	mtd-utils-ubifs \
	dtc \
	dtc-misc \
	iproute2 \
	iptables \
	can-utils \
	mpio \
	gdbserver \
	evtest \
	\
	cjson \
	lua-staticdev \
	libplanes \
	\
	qtbase \
	qtbase-plugins \
	qtbase-tools \
	qtmultimedia \
	qtmultimedia-plugins \
	qtmultimedia-qmlplugins \
	qtsensors \
	qtserialport \
	qtsystems \
	qtsystems-tools \
	qtsystems-qmlplugins \
	qtscript \
	qtgraphicaleffects-qmlplugins \
	qtconnectivity-qmlplugins \
	qtlocation-plugins \
	qtlocation-qmlplugins \
	qtdeclarative \
	qtdeclarative-qmlplugins \
	qtquick1 \
	qtquick1-qmlplugins \
	qtquick1-plugins \
	qtquickcontrols \
	qtquickcontrols-qmlplugins \
	qtquickcontrols2 \
	qtquickcontrols2-qmlplugins \
	qtwebkit \
	qtwebkit-qmlplugins \
	qtimageformats \
	libicui18n \
	libv4l \
	v4l-utils \
	ffmpeg \
	liberation-fonts \
	pkgconfig \
  libsocketcan \
  lightctld \
  canquick-init \
  canquick-local \
  strace \
"



inherit core-image populate_sdk_qt5
