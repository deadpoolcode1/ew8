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
    entitytype.cpp \

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
    resources/EWAlerts/blinkers.png \
    resources/EWAlerts/fcw.png \
    resources/EWAlerts/fla_armed.png \
    resources/EWAlerts/hmwa03.png \
    resources/EWAlerts/hmwa04.png \
    resources/EWAlerts/hmwa05.png \
    resources/EWAlerts/hmwa06.png \
    resources/EWAlerts/hmwa07.png \
    resources/EWAlerts/hmwa08.png \
    resources/EWAlerts/hmwm06.png \
    resources/EWAlerts/hmwm07.png \
    resources/EWAlerts/hmwm08.png \
    resources/EWAlerts/hmwm09.png \
    resources/EWAlerts/hmwm10.png \
    resources/EWAlerts/hmwm11.png \
    resources/EWAlerts/hmwm12.png \
    resources/EWAlerts/hmwm13.png \
    resources/EWAlerts/hmwm14.png \
    resources/EWAlerts/hmwm15.png \
    resources/EWAlerts/hmwm16.png \
    resources/EWAlerts/hmwm17.png \
    resources/EWAlerts/hmwm18.png \
    resources/EWAlerts/hmwm19.png \
    resources/EWAlerts/hmwm21.png \
    resources/EWAlerts/hmwm22.png \
    resources/EWAlerts/hmwm23.png \
    resources/EWAlerts/hmwm24.png \
    resources/EWAlerts/hmwm25.png \
    resources/EWAlerts/ldwoff.png \
    resources/EWAlerts/ldwon.png \
    resources/EWAlerts/lldw.png \
    resources/EWAlerts/pcw.png \
    resources/EWAlerts/pdz.png \
    resources/EWAlerts/rldw.png \
    resources/EWAlerts/sli.png \
    resources/EWAlerts/fla_armed_low.png \
    resources/EWAlerts/forward.svg

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
    alerttypes.h \

win32: LIBS += -L'C:/Program Files (x86)/Kvaser/Canlib/Lib/MS/' -lcanlib32

win32: INCLUDEPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'
win32: DEPENDPATH += 'C:/Program Files (x86)/Kvaser/Canlib/INC'


#Specific preprocessor definitions:
DEFINES += VERIFY_ALL_ALERTS_IMPLEMENTED
