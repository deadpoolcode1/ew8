qmlscripts.files = *.qml
qmlimages.files = resources/*
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
    candbsignal.cpp

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
    SmartItem.qml

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
    candbsignal.h

win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

linux: LIBS += -L'/opt/poky-atmel/2.4.2/sysroots/cortexa5hf-neon-poky-linux-gnueabi/usr/lib/' -lsocketcan
linux: INCLUDEPATH += -I'/opt/poky-atmel/2.4.2/sysroots/cortexa5hf-neon-poky-linux-gnueabi/usr/include/'


#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"

win32: QMAKE_POST_LINK += $(MAKE) install
