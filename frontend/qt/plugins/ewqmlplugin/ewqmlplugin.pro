TEMPLATE = lib
TARGET = ewqmlplugin
QT += qml quick
CONFIG += plugin c++11

TARGET = $$qtLibraryTarget($$TARGET)
uri = com.mobileye

# Input
SOURCES +=         ewqmlplugin_plugin.cpp         qquickhalfcircletray.cpp

HEADERS +=         ewqmlplugin_plugin.h         qquickhalfcircletray.h

DISTFILES = qmldir

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) "$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)" "$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

win32 {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

win32: QMAKE_POST_LINK += $(MAKE) install

win32 {
plugindump.target = .buildfile
plugindump.commands = $$[QT_HOST_BIN]/qmlplugindump com.mobileye 1.0 > $$installPath/plugins.qmltypes

QMAKE_EXTRA_TARGETS += plugindump
}
