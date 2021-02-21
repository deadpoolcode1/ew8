#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "qquickqrcode.h"

#include "mainprocess.h"
#include "alerttypes.h"

#include "amjsonsignal.h"

#include "defs.h"

#include <QResource>
#include <QFile>
#include <QDir>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include <QScreen>
#include "brightnesscontrol.h"


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

class AlertTypes;
class QQuickQRCode;

QElapsedTimer bootUpTimer;

int main(int argc, char *argv[])
{
    bootUpTimer.start();

    qDebug() << "Initialization begins, time" << bootUpTimer.elapsed();

#ifdef LOG_INIT_COMPLETE_TO_DMESG
    QFile kernMsgDev("/dev/kmsg");

    if(kernMsgDev.open(QFile::WriteOnly | QFile::Text))
    {
       kernMsgDev.write("<2> canquick: init started");
       kernMsgDev.close();
    }

#endif



#if 0
    qDebug() << "Supported Animated Formats" << QImageReader::supportedImageFormats();
#endif

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    system("killall -USR1 ew8_splash");


    QGuiApplication app(argc,argv);

    app.setOrganizationName("mobileye");

    BrightnessControl brightnessControl(&app);


    QCommandLineParser cmdLnParser;

    QCommandLineOption forceParsing(QStringList() << "f" << "force-parsing", "Parsing config files, even cache is available");

    cmdLnParser.addOption(forceParsing);

    cmdLnParser.process(app);

    //TODO: implement forced parsing in code
    bool is_forced = cmdLnParser.isSet(forceParsing);

    if(is_forced)
    {
        CanRxMsg::forceDBCParsing();
    }


    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();

    QQmlApplicationEngine engine;

    QUrl mainQmlUrl;


    //TODO: check if main.rcc exists and register
    if(!is_forced && QResource::registerResource((QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.rcc"))))
    {
         engine.addImportPath(":/");
         mainQmlUrl = QUrl(QStringLiteral("qrc:/main.qml"));
    }
    else
    {
        mainQmlUrl = QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml"));
    }

    QQmlComponent component(&engine, mainQmlUrl);



    QObject * componentObject = component.create();

    qDebug() << "Component created, time" << bootUpTimer.elapsed();



    MainProcess* mp = MainProcess::getInstance(componentObject);

    mp->setBrightnessControl(& brightnessControl);

    CanRxMsg::saveToStorage();

    qDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();



    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time:" << bootUpTimer.elapsed();




#ifdef LOG_INIT_COMPLETE_TO_DMESG

    if(kernMsgDev.open(QFile::WriteOnly | QFile::Text))
    {
       kernMsgDev.write("<2> canquick: in main loop");
       kernMsgDev.close();
    }

#endif

#ifndef WIN32

        system("killall -USR2 ew8_splash");

#endif

    return app.exec();
}
