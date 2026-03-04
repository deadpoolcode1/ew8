MAJOR_VERSION = 3
MINOR_VERSION = 0
OTA_TEST_VERSION = 0

VERSION = $${MAJOR_VERSION}"."$${MINOR_VERSION}"."$${OTA_TEST_VERSION}
message(Version $${VERSION})

DEFINES += MAJOR_VERSION=$${MAJOR_VERSION}
DEFINES += MINOR_VERSION=$${MINOR_VERSION}
DEFINES += OTA_TEST_VERSION=$${OTA_TEST_VERSION}

qmlscripts.files = qml/*.qml qml/*.js
qmlimages.files = qml/images/*
signalcfgs.files = signals/*.json
configs.files = configs/*.json
dbcfiles.files = DBC/*.dbc
rccfiles.files = qml/*.rcc
fontfiles.files = qml/fonts/*

win32: batches.files = *.bat

GRAMMARFILE = backend/candbgrammar.peg

CANDBGRAMMAR = $$cat($${GRAMMARFILE},blob)
QMAKE_SUBSTITUTES += backend/candbgrammar.h.in

QT += quick
# QT += sensors

CONFIG += c++17

# Include paths for reorganized directory layout
INCLUDEPATH += backend/include
INCLUDEPATH += frontend/qt/include
INCLUDEPATH += $${OUT_PWD}/backend

# Workaround for Qt 6.9.x qfloat16 bug on 64-bit Linux
# Qt declares comparison operators for both 'long' and 64-bit integer types, but on LP64
# they are the same type, causing redefinition errors in qfloat16.h
# See: https://doc.qt.io/qt-6/qfloat16.html
linux {
    # Disable qfloat16 arithmetic/comparison operators which cause conflicts on LP64
    DEFINES += QT_NO_FLOAT16_OPERATORS
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    backend/src/bufferedsmoother.cpp \
    backend/src/keepalivemsg.cpp \
    backend/src/versionmsg.cpp \
    frontend/qt/src/main.cpp \
    backend/src/canmanager.cpp \
    frontend/qt/src/mainprocess.cpp \
    frontend/qt/src/rootedtreenode.cpp \
    frontend/qt/src/rootedtree.cpp \
    backend/src/layerspriorityq.cpp \
    backend/src/entitytype.cpp \
    backend/src/canrxmsg.cpp \
    backend/src/canrxmsgfactory.cpp \
    frontend/qt/src/displaysignalizer.cpp \
    frontend/qt/src/qquickqrcode.cpp \
    backend/src/amsignalsmodel.cpp \
    backend/src/amjsonprotocol.cpp \
    backend/src/amjsonsignal.cpp \
    backend/src/canstringargumentsaccumulator.cpp \
    backend/src/canintargumentsaccumulator.cpp \
    backend/src/canargumentsaccumulator.cpp \
    backend/src/amjsonconfigreader.cpp \
    backend/src/graphicitemsenummap.cpp \
    backend/src/amjsonaction.cpp \
    backend/src/amjsongraphicitemaction.cpp \
    backend/src/amjsonenableraction.cpp \
    backend/src/amjsonargumentaction.cpp \
    backend/src/amjsonstringargumentaction.cpp \
    backend/src/amjsonnumericargumentaction.cpp \
    backend/src/amjsonactionfactory.cpp \
    backend/src/amjsonactionsmultiplexor.cpp \
    backend/src/candbsignal.cpp \
    backend/src/amjsonfixedargumentsactioninvoker.cpp \
    backend/src/medisconnectionreport.cpp \
    backend/src/amjsonrequestidaction.cpp \
    backend/src/watchdogdevice.cpp \
    backend/src/amjsonsystemrequestaction.cpp \
    backend/src/timedsmoother.cpp \
    backend/src/brightnesscontrol.cpp \
    backend/src/candebugreport.cpp \
    frontend/qt/src/ewinfo.cpp \
    backend/src/snv_calculator.cpp \
    backend/src/version_info.cpp \
    backend/src/alertcontroller.cpp \
    backend/src/app_init.cpp \
    backend/src/display_tree.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Additional files to deploy:
win32: qmlscripts.path = $${OUT_PWD}/qml
qnx: qmlscripts.path = /tmp/$${TARGET}/qml
else: unix:!android: qmlscripts.path = /opt/$${TARGET}/qml
!isEmpty(qmlscripts.path): INSTALLS += qmlscripts

!android: qmlimages.path = $${qmlscripts.path}/images
!isEmpty(qmlimages.path): INSTALLS += qmlimages

win32: fontfiles.path = $${OUT_PWD}/qml/fonts
qnx: signalcfgs.path = /tmp/$${TARGET}/qml/fonts
else: unix:!android: fontfiles.path = /opt/$${TARGET}/qml/fonts
!isEmpty(fontfiles.path): INSTALLS += fontfiles

win32: signalcfgs.path = $${OUT_PWD}/signals
qnx: signalcfgs.path = /tmp/$${TARGET}/signals
else: unix:!android: signalcfgs.path = /opt/$${TARGET}/signals
!isEmpty(signalcfgs.path): INSTALLS += signalcfgs

win32: configs.path = $${OUT_PWD}/configs
qnx: configs.path = /tmp/$${TARGET}/configs
else: unix:!android: configs.path = /opt/$${TARGET}/configs
!isEmpty(configs.path): INSTALLS += configs


win32: dbcfiles.path = $${OUT_PWD}/dbc
qnx: dbcfiles.path = /tmp/$${TARGET}/dbc
else: unix:!android: dbcfiles.path = /opt/$${TARGET}/dbc
!isEmpty(dbcfiles.path): INSTALLS += dbcfiles

win32: rccfiles.path = $${OUT_PWD}/qml
qnx: rccfiles.path = /tmp/$${TARGET}/qml
else: unix:!android: rccfiles.path = /opt/$${TARGET}/qml
!isEmpty(rccfiles.path): INSTALLS += rccfiles



win32: batches.path = $${OUT_PWD}
!isEmpty(batches.path): INSTALLS += batches

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES =

HEADERS += \
    frontend/qt/include/qt_workarounds.h \
    backend/include/alerttypes_core.h \
    backend/include/idisplaynode.h \
    backend/include/bufferedsmoother.h \
    backend/include/keepalivemsg.h \
    backend/include/versionmsg.h \
    backend/include/peglib.h \
    backend/include/canmanager.h \
    backend/include/ialertdisplay.h \
    backend/include/icanrxmsgfactory.h \
    frontend/qt/include/mainprocess.h \
    frontend/qt/include/rootedtreenode.h \
    frontend/qt/include/rootedtree.h \
    backend/include/defs.h \
    backend/include/layerspriorityq.h \
    backend/include/entitytype.h \
    frontend/qt/include/alerttypes.h \
    backend/include/canrxmsg.h \
    backend/include/canrxmsgfactory.h \
    frontend/qt/include/displaysignalizer.h \
    backend/include/candbsignal.h \
    frontend/qt/include/qquickqrcode.h \
    backend/include/amsignalsmodel.h \
    backend/include/amjsonprotocol.h \
    backend/include/amjsonsignal.h \
    backend/include/canstringargumentsaccumulator.h \
    backend/include/canintargumentsaccumulator.h \
    backend/include/canargumentsaccumulator.h \
    backend/include/amjsonconfigreader.h \
    backend/include/graphicitemsenummap.h \
    backend/include/amjsonaction.h \
    backend/include/amjsongraphicitemaction.h \
    backend/include/amjsonenableraction.h \
    backend/include/amjsonargumentaction.h \
    backend/include/amjsonstringargumentaction.h \
    backend/include/amjsonnumericargumentaction.h \
    backend/include/iamjsonactionfactory.h \
    backend/include/amjsonactionfactory.h \
    backend/include/amjsonactionsmultiplexor.h \
    backend/include/actiontype.h \
    backend/candbgrammar.h.in \
    backend/candbgrammar.peg \
    backend/include/amjsonfixedargumentsactioninvoker.h \
    backend/include/iamjsonprocessable.h \
    backend/include/medisconnectionreport.h \
    backend/include/amjsonrequestidaction.h \
    backend/include/watchdogdevice.h \
    backend/include/amjsonsystemrequestaction.h \
    backend/include/ismoother.h \
    backend/include/timedsmoother.h \
    backend/include/brightnesscontrol.h \
    backend/include/sysreqtype.h \
    backend/include/candebugreport.h \
    frontend/qt/include/ewinfo.h \
    backend/include/snv_calculator.h \
    backend/include/version_info.h \
    backend/include/alertcontroller.h \
    backend/include/app_init.h \
    backend/include/display_tree.h

# =============================================================================
# PLATFORM-SPECIFIC CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Windows Configuration
# -----------------------------------------------------------------------------
win32 {
    message("Building for Windows")

    # Kvaser CAN library
    LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32
    INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
    DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

    # QREncode library
    LIBS += -L"C:/Program Files (x86)/qrencode-win32/Lib/" -lqrcodelib
    INCLUDEPATH += 'C:/Program Files (x86)/qrencode-win32/INC'
    DEPENDPATH += 'C:/Program Files (x86)/qrencode-win32/INC'

    # Windows uses different CAN code paths, no REMOVE_EW8_HW needed
}

# -----------------------------------------------------------------------------
# Linux Configuration
# -----------------------------------------------------------------------------
linux {
    LIBS += -lsocketcan -lqrencode -ldrm
    DEFINES += LOG_INIT_COMPLETE_TO_DMESG

    # Detect if building for desktop (x86_64) or embedded ARM
    contains(QMAKE_HOST.arch, x86_64) {
        message("Building for Linux Desktop (x86_64)")

        # Disable hardware-specific code for desktop simulation
        DEFINES += REMOVE_EW8_HW

        # Use current directory for resources in desktop builds
        DEFINES -= "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"

        # Post-build: Setup symlinks and CAN interface
        QMAKE_POST_LINK += $$quote(echo "=== Post-build setup ===" &&)
        QMAKE_POST_LINK += $$quote(sudo mkdir -p /opt/canquick/bin 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ln -sf $$PWD/qml /opt/canquick/qml 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ln -sf $$PWD/signals /opt/canquick/signals 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ln -sf $$PWD/configs /opt/canquick/configs 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ln -sf $$PWD/DBC /opt/canquick/dbc 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(echo "Symlinks created in /opt/canquick/" &&)
        QMAKE_POST_LINK += $$quote(sudo modprobe vcan 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ip link add dev can0 type vcan 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(sudo ip link set up can0 2>/dev/null || true &&)
        QMAKE_POST_LINK += $$quote(echo "Virtual CAN interface can0 ready")

    } else:contains(QMAKE_HOST.arch, arm.*)|contains(QMAKE_HOST.arch, aarch64) {
        message("Building for Linux ARM (embedded target)")
        # Real hardware - do NOT define REMOVE_EW8_HW
    } else {
        message("Building for Linux (unknown arch: $$QMAKE_HOST.arch)")
    }
}

# -----------------------------------------------------------------------------
# Common Definitions
# -----------------------------------------------------------------------------
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"

#DEFINES += VIRTUAL_CAN0
