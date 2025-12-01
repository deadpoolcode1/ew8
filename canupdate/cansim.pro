win32: batches.files = *.bat

TARGET = cansim

QT += quick
CONFIG += console
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

DEFINES += CANSIM

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    mainprocessapi.cpp \
    updatecommon/crc32.cpp \
        main.cpp \
    updatecommon/caninterface.cpp \
    updatecommon/sha256.cpp \
    updateapi/updatecanapi.cpp \
    updatecommon/updatecanprotocol.cpp \
    updateapi/updatesample.cpp \
    updatecommon/utils.cpp



# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

win32: batches.path = $${OUT_PWD}
!isEmpty(batches.path): INSTALLS += batches

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES =

HEADERS += \
    mainprocessapi.h \
    updatecommon/canreceptor.h \
    updatecommon/crc32.h \
    updatecommon/caninterface.h \
    updatecommon/sha256.h \
    updateapi/updatecanapi.h \
    updatecommon/updatecanprotocol.h \
    updateapi/updatesample.h \
    updatecommon/utils.h \
    updatecommon/version.h


win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'

linux: LIBS += -lsocketcan

#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED

!isEmpty(target.path): DEFINES += "BASE_TARGET_DIR=\'\"$${target.path}/../\"\'"
else: DEFINES += "BASE_TARGET_DIR=\'\"\"\'"

win32: QMAKE_POST_LINK += $(MAKE) install
