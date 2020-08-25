MAJOR_VERSION = 0
MINOR_VERSION = 2

VERSION = $${MAJOR_VERSION}"."$${MINOR_VERSION}
message(Version $${VERSION})

DEFINES += MAJOR_VERSION=$${MAJOR_VERSION}
DEFINES += MINOR_VERSION=$${MINOR_VERSION}

qmlscripts.files = qml/*.qml
qmlimages.files = qml/images/*
signalcfgs.files = *.json
dbcfiles.files = DBC/*.dbc
rccfiles.files = qml/*.rcc

win32: batches.files = *.bat

GRAMMARFILE = candbgrammar.peg

CANDBGRAMMAR = $$cat($${GRAMMARFILE},blob)
QMAKE_SUBSTITUTES += candbgrammar.h.in

QT += quick

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
    watchdogdevice.cpp

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

win32: signalcfgs.path = $${OUT_PWD}/signals
qnx: signalcfgs.path = /tmp/$${TARGET}/signals
else: unix:!android: signalcfgs.path = /opt/$${TARGET}/signals
!isEmpty(signalcfgs.path): INSTALLS += signalcfgs

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
    amjsonfixedargumentsactioninvoker.h \
    iamjsonprocessable.h \
    medisconnectionreport.h \
    amjsonrequestidaction.h \
    watchdogdevice.h


win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

win32: LIBS += -L"C:/Program Files (x86)/qrencode-win32/Lib/" -lqrcodelib

win32: INCLUDEPATH += 'C:/Program Files (x86)/qrencode-win32/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/qrencode-win32/INC'

linux: LIBS += -lsocketcan -lqrencode -lwebp

linux: DEFINES += LOG_INIT_COMPLETE_TO_DMESG

#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"




