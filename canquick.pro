MAJOR_VERSION = 1
MINOR_VERSION = 4
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

GRAMMARFILE = candbgrammar.peg

CANDBGRAMMAR = $$cat($${GRAMMARFILE},blob)
QMAKE_SUBSTITUTES += candbgrammar.h.in

QT += quick
# QT += sensors

CONFIG += c++11

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
    bufferedsmoother.cpp \
    keepalivemsg.cpp \
    versionmsg.cpp \
        main.cpp \
    canmanager.cpp \
    mainprocess.cpp \
    rootedtreenode.cpp \
    rootedtree.cpp \
    layerspriorityq.cpp \
    entitytype.cpp \
    canrxmsg.cpp \
    canrxmsgfactory.cpp \
    displaysignalizer.cpp \
    qquickqrcode.cpp \
    amsignalsmodel.cpp \
    amjsonprotocol.cpp \
    amjsonsignal.cpp \
    canstringargumentsaccumulator.cpp \
    canintargumentsaccumulator.cpp \
    canargumentsaccumulator.cpp \
    amjsonconfigreader.cpp \
    graphicitemsenummap.cpp \
    amjsonaction.cpp \
    amjsongraphicitemaction.cpp \
    amjsonenableraction.cpp \
    amjsonargumentaction.cpp \
    amjsonstringargumentaction.cpp \
    amjsonnumericargumentaction.cpp \
    amjsonactionfactory.cpp \
    amjsonactionsmultiplexor.cpp \
    candbsignal.cpp \
    amjsonfixedargumentsactioninvoker.cpp \
    medisconnectionreport.cpp \
    amjsonrequestidaction.cpp \
    watchdogdevice.cpp \
    amjsonsystemrequestaction.cpp \
    timedsmoother.cpp \
    brightnesscontrol.cpp \
    candebugreport.cpp

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
    bufferedsmoother.h \
    keepalivemsg.h \
    versionmsg.h \
    peglib.h \
    canmanager.h \
    ialertdisplay.h \
    icanrxmsgfactory.h \
    mainprocess.h \
    rootedtreenode.h \
    rootedtree.h \
    defs.h \
    layerspriorityq.h \
    entitytype.h \
    alerttypes.h \
    canrxmsg.h \
    canrxmsgfactory.h \
    displaysignalizer.h \
    candbsignal.h \
    qquickqrcode.h \
    amsignalsmodel.h \
    amjsonprotocol.h \
    amjsonsignal.h \
    canstringargumentsaccumulator.h \
    canintargumentsaccumulator.h \
    canargumentsaccumulator.h \
    amjsonconfigreader.h \
    graphicitemsenummap.h \
    amjsonaction.h \
    amjsongraphicitemaction.h \
    amjsonenableraction.h \
    amjsonargumentaction.h \
    amjsonstringargumentaction.h \
    amjsonnumericargumentaction.h \
    iamjsonactionfactory.h \
    amjsonactionfactory.h \
    amjsonactionsmultiplexor.h \
    actiontype.h \
    candbgrammar.h.in \
    candbgrammar.peg \
    amjsonfixedargumentsactioninvoker.h \
    iamjsonprocessable.h \
    medisconnectionreport.h \
    amjsonrequestidaction.h \
    watchdogdevice.h \
    amjsonsystemrequestaction.h \
    ismoother.h \
    timedsmoother.h \
    brightnesscontrol.h \
    sysreqtype.h \
    candebugreport.h


win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

win32: LIBS += -L"C:/Program Files (x86)/qrencode-win32/Lib/" -lqrcodelib

win32: INCLUDEPATH += 'C:/Program Files (x86)/qrencode-win32/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/qrencode-win32/INC'

linux: LIBS += -lsocketcan -lqrencode -lwebp -ldrm

linux: DEFINES += LOG_INIT_COMPLETE_TO_DMESG

#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"




