DESCRIPTION = "An image that will launch into the demo application for the embedded (not based on X11) version of Qt."
LICENSE = "CLOSED"
PR = "r0"

IMAGE_FEATURES += "ssh-server-openssh package-management"

IMAGE_INSTALL += "\
	packagegroup-core-boot \
	packagegroup-core-full-cmdline \
	packagegroup-base-wifi \
	packagegroup-base-bluetooth \
	packagegroup-base-usbgadget \
	openssh-sftp \
	openssh-sftp-server \
	kernel-modules \
	lrzsz \
	setserial \
	opkg \
	iperf3 \
	\
	nbench-byte \
	lmbench \
	\
	linux-firmware-ralink \
	linux-firmware-ath6k \
	\
	alsa-utils \
	mpg123 \
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
	bridge-utils \
	can-utils \
	python-pyserial \
	python-smbus \
	python-ctypes \
	python-pip \
	python-distribute \
	python-pyqt5 \
	mpio \
	gdbserver \
	evtest \
	mxt-app \
	usbutils \
	wget \
	${CORE_IMAGE_BASE_INSTALL} \
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
	gstreamer1.0 \
	gstreamer1.0-plugins-bad-meta \
	gstreamer1.0-plugins-base-meta \
	gstreamer1.0-plugins-good-meta \
	gstreamer1.0-plugins-ugly-meta \
	gstreamer1.0-libav \
	libv4l \
	v4l-utils \
	fswebcam \
	ffmpeg \
	liberation-fonts \
	pkgconfig \
  libsocketcan \
  lightctld \
  canquick-init \
  canquick \
  strace \
  systemd-bootchart \
  swupdate \
  canupdate \
  canupdate-init\
  synthsample\
  bscrwrite \
"



inherit core-image populate_sdk_qt5
