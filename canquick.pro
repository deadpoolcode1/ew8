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
    qmltreeparser.cpp \
    rootedtreenode.cpp \
    rootedtree.cpp \
    layerspriorityq.cpp \
    entitytype.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    resources/sp_red_h.png \
    resources/sp_yellow_h.png \
    resources/alfa_romeo_PNG75.png \
    resources/camaro_PNG34.png \
    resources/EWAlerts/Artboard 88.png \
    resources/EWAlerts/Artboard 88 copy.png \
    resources/EWAlerts/Artboard 88 copy 2.png \
    resources/EWAlerts/Artboard 88 copy 3.png \
    resources/EWAlerts/Artboard 88 copy 4.png \
    resources/EWAlerts/Artboard 88 copy 5.png \
    resources/EWAlerts/Artboard 88 copy 6.png \
    resources/EWAlerts/Artboard 88 copy 7.png \
    resources/EWAlerts/Artboard 88 copy 8.png \
    resources/EWAlerts/Artboard 88 copy 9.png \
    resources/EWAlerts/Artboard 88 copy 10.png \
    resources/EWAlerts/Artboard 88 copy 11.png \
    resources/EWAlerts/Artboard 88 copy 12.png \
    resources/EWAlerts/Artboard 88 copy 13.png \
    resources/EWAlerts/Artboard 88 copy 14.png \
    resources/EWAlerts/Artboard 88 copy 15.png \
    resources/EWAlerts/Artboard 88 copy 16.png \
    resources/EWAlerts/Artboard 88 copy 17.png \
    resources/EWAlerts/Artboard 88 copy 18.png \
    resources/EWAlerts/Artboard 88 copy 19.png \
    resources/EWAlerts/Artboard 88 copy 20.png \
    resources/EWAlerts/Artboard 88 copy 21.png \
    resources/EWAlerts/Artboard 88 copy 22.png \
    resources/EWAlerts/Artboard 88 copy 23.png \
    resources/EWAlerts/Artboard 88 copy 24.png \
    resources/EWAlerts/Artboard 88 copy 25.png \
    resources/EWAlerts/Artboard 88 copy 26.png \
    resources/EWAlerts/Artboard 88 copy 27.png \
    resources/EWAlerts/Artboard 88 copy 28.png \
    resources/EWAlerts/Artboard 88 copy 29.png \
    resources/EWAlerts/Artboard 88 copy 30.png \
    resources/EWAlerts/Artboard 88 copy 31.png \
    resources/EWAlerts/Artboard 88 copy 32.png \
    resources/EWAlerts/Artboard 88 copy 33.png \
    resources/EWAlerts/Artboard 88 copy 34.png \
    resources/EWAlerts/Artboard 88 copy 35.png \
    resources/EWAlerts/Artboard 88 copy 36.png

HEADERS += \
    canmanager.h \
    ialertdisplay.h \
    mainprocess.h \
    qmltreeparser.h \
    rootedtreenode.h \
    rootedtree.h \
    defs.h \
    layerspriorityq.h \
    entitytype.h \
    alerttypes.h

win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
