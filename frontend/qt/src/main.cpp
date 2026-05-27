#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "core/core.h"
#include "qquickqrcode.h"

#include "mainprocess.h"
#include "alerttypes.h"

#include "defs.h"

#include "core/file_utils.h"
#include "core/resource_paths.h"
#include <QScreen>
#include "brightnesscontrol.h"

#include "ewinfo.h"
#include "app_init.h"

#ifndef WIN32
#include <sys/types.h>
#include <signal.h>


#if 1
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <sys/ioctl.h>


#include <drm/drm.h>
#include <drm/drm_mode.h>
#endif
#endif

class QQuickQRCode;
class EWInfo;

core::ElapsedTimer bootUpTimer;

int main(int argc, char *argv[])
{
    bootUpTimer.start();

#ifdef REMOVE_EW8_HW
    // Auto-setup virtual CAN for desktop builds
    if (system("ip link show can0 > /dev/null 2>&1") != 0) {
        coreDebug() << "Setting up virtual CAN interface...";
        system("sudo /usr/sbin/modprobe vcan 2>/dev/null");
        system("sudo /usr/sbin/ip link add dev can0 type vcan 2>/dev/null");
        system("sudo /usr/sbin/ip link set up can0 2>/dev/null");
    }
#endif

    coreDebug() << "Initialization begins, time" << bootUpTimer.elapsed();

#ifdef LOG_INIT_COMPLETE_TO_DMESG
    core::File kernMsgDev("/dev/kmsg");

    if(kernMsgDev.open(core::File::WriteOnly | core::File::Text))
    {
       kernMsgDev.write("<2> canquick: init started");
       kernMsgDev.close();
    }

#endif



#if 0
    coreDebug() << "Supported Animated Formats" << QImageReader::supportedImageFormats();
#endif

    // Qt::AA_EnableHighDpiScaling is deprecated in Qt 6 - High-DPI scaling is always enabled
#ifdef REMOVE_EW8_HW
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);
#endif

#ifndef WIN32
    system("killall -USR1 ew8_splash");
#endif

    AppConfig config = parseAppConfig(argc, argv);
    initializeBackend(config);

    QGuiApplication app(argc,argv);

    app.setOrganizationName("mobileye");

#ifndef REMOVE_EW8_HW
    BrightnessControl brightnessControl;
#endif

    //Usage of QML enum in C++:
    AlertTypesQml::declareQML();
    QQuickQRCode::declareQML();
    EWInfo::declareQML();

    QQmlApplicationEngine engine;

    // Resolve the QML directory relative to the executable at runtime via
    // resourceBaseDir() (the same lookup the backend uses for configs/dbc),
    // instead of the compile-time BASE_TARGET_DIR. The QML files are deployed
    // next to the binary in qml/, so they load from disk and stay editable
    // after compilation (IMS-11653).
    std::string mainQmlPath = core::resourceBaseDir() + "qml/" + config.mainQmlFileName;

    // Only construct QUrl inline where required by Qt QML APIs
    QQmlComponent component(&engine, QUrl::fromLocalFile(String(mainQmlPath).toQString()));
    coreDebug() << "Loading QML from:" << mainQmlPath;
    coreDebug() << "Component status:" << component.status();
if (component.status() != QQmlComponent::Ready) {
    coreDebug() << "QML errors:" << component.errorString();
}

    QObject * componentObject = component.create();

    coreDebug() << "Component created, time" << bootUpTimer.elapsed();

    MainProcess* mp = MainProcess::getInstance(componentObject);

#ifndef REMOVE_EW8_HW
    mp->setBrightnessControl(& brightnessControl);
#endif

    postLaunchBackend(config);

    coreDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();

    mp->launchEverything();

    coreDebug() << "Core Application Loop begins, time:" << bootUpTimer.elapsed();




#ifdef LOG_INIT_COMPLETE_TO_DMESG


    if ( ! config.testingMode)
    {
        if (kernMsgDev.open(core::File::WriteOnly | core::File::Text))
        {
           kernMsgDev.write("<2> canquick: in main loop");
           kernMsgDev.close();
        }
    }

#endif

#ifndef WIN32

    if ( ! config.testingMode)
    {
        system("killall -USR2 ew8_splash");
    }

#endif

    return app.exec();
}
