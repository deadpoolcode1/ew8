qmlscripts.files = *.qml
qmlimages.files = resources/*
signalcfgs.files = *.json
dbcfiles.files = *.dbc

win32: batches.files = *.bat

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
        main.cpp \
    canmanager.cpp \
    mainprocess.cpp \
    rootedtreenode.cpp \
    rootedtree.cpp \
    layerspriorityq.cpp \
    entitytype.cpp \
    canrxmsg.cpp \
    simplecanrxmsg.cpp \
    smartcanrxmsg.cpp \
    awscanrxmsg.cpp \
    tsrcanrxmsg.cpp \
    canrxmsgfactory.cpp \
    smartitem.cpp \
    displaysignalizer.cpp \
    candbsignal.cpp \
    qquickqrcode.cpp \
    amsignalsmodel.cpp \
    amjsonprotocol.cpp \
    amjsonsignal.cpp \
    \
    canstringargumentsaccumulator.cpp \
    seeqsysinfocanrxmsg.cpp \
    seeqtimeinfocanrxmsg.cpp \
    canintargumentsaccumulator.cpp \
    canargumentsaccumulator.cpp \
    amjsonconfigreader.cpp \
    graphicitemsenummap.cpp

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

win32: qmlimages.path = $${OUT_PWD}/images
qnx: qmlimages.path = /tmp/$${TARGET}/images
else: unix:!android: qmlimages.path = /opt/$${TARGET}/images
!isEmpty(qmlimages.path): INSTALLS += qmlimages

win32: signalcfgs.path = $${OUT_PWD}/signals
qnx: signalcfgs.path = /tmp/$${TARGET}/signals
else: unix:!android: signalcfgs.path = /opt/$${TARGET}/signals
!isEmpty(signalcfgs.path): INSTALLS += signalcfgs

win32: dbcfiles.path = $${OUT_PWD}/dbc
qnx: dbcfiles.path = /tmp/$${TARGET}/dbc
else: unix:!android: dbcfiles.path = /opt/$${TARGET}/dbc
!isEmpty(dbcfiles.path): INSTALLS += dbcfiles



win32: batches.path = $${OUT_PWD}
!isEmpty(batches.path): INSTALLS += batches

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    resources/EWAlerts/blinkers.png \
    resources/EWAlerts/fcw.png \
    resources/EWAlerts/fla_armed.png \
    resources/EWAlerts/ldwoff.png \
    resources/EWAlerts/ldwon.png \
    resources/EWAlerts/lldw.png \
    resources/EWAlerts/pcw.png \
    resources/EWAlerts/pdz.png \
    resources/EWAlerts/rldw.png \
    resources/EWAlerts/sli.png \
    resources/EWAlerts/fla_armed_low.png \
    resources/EWAlerts/forward.svg \
    resources/EWAlerts/hmw_green.png \
    resources/EWAlerts/hmw_red.png \
    resources/EWAlerts/end_all_restr.svg \
    resources/EWAlerts/motorway.svg \
    resources/EWAlerts/no_pass.svg \
    resources/EWAlerts/playground.svg \
    TSR.qml \
    SmartItem.qml \
    resources/Containers/Artboard 40@2x.png \
    resources/Containers/example@2x.png \
    resources/Containers/Left-frame@2x.png \
    resources/Containers/logo@2x.png \
    resources/Containers/right-frame@2x.png \
    resources/Containers/top-bar-frame@2x.png \
    resources/SmartAlerts/bww@2x.png \
    resources/SmartAlerts/coffee@2x.png \
    resources/Statuses/gps@2x.png \
    resources/Statuses/ihc@2x.png \
    resources/Statuses/ihc_low@2x.png \
    resources/Statuses/OTA@2x.png \
    resources/Statuses/ts@2x.png \
    resources/TSRAlerts/sli@2x.png \
    resources/SmartAlerts/animal.svg \
    resources/SmartAlerts/slippery.svg

HEADERS += \
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
    simplecanrxmsg.h \
    smartcanrxmsg.h \
    awscanrxmsg.h \
    tsrcanrxmsg.h \
    canrxmsgfactory.h \
    smartitem.h \
    displaysignalizer.h \
    candbsignal.h \
    qquickqrcode.h \
    amsignalsmodel.h \
    amjsonprotocol.h \
    amjsonsignal.h \
    canstringargumentsaccumulator.h \
    seeqsysinfocanrxmsg.h \
    seeqtimeinfocanrxmsg.h \
    canintargumentsaccumulator.h \
    canargumentsaccumulator.h \
    amjsonconfigreader.h \
    graphicitemsenummap.h


win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

win32: LIBS += -L"C:/Program Files (x86)/qrencode-win32/Lib/" -lqrcodelib

win32: INCLUDEPATH += 'C:/Program Files (x86)/qrencode-win32/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/qrencode-win32/INC'

linux: LIBS += -L'/opt/poky-atmel/2.4.2/sysroots/cortexa5hf-neon-poky-linux-gnueabi/usr/lib/' -lsocketcan -lqrencode

# WARNING: INCLUDEPATH @ linux is buggy  -- qtcreator does not see the headers for auto completion
#linux: INCLUDEPATH += -I'/opt/poky-atmel/2.4.2/sysroots/cortexa5hf-neon-poky-linux-gnueabi/usr/include/'
linux: QMAKE_CXXFLAGS += -I'/opt/poky-atmel/2.4.2/sysroots/cortexa5hf-neon-poky-linux-gnueabi/usr/include/'

#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"

win32: QMAKE_POST_LINK += $(MAKE) install
