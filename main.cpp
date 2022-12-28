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
#include "amjsonconfigreader.h"

#include "ewinfo.h"

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
class EWInfo;
class AMJsonConfigReader;

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
#ifdef REMOVE_EW8_HW
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);
#endif

#ifndef WIN32
    system("killall -USR1 ew8_splash");
#endif


    QGuiApplication app(argc,argv);

    app.setOrganizationName("mobileye");

#ifndef REMOVE_EW8_HW
    BrightnessControl brightnessControl(&app);
#endif

    QCommandLineParser cmdLnParser;
    QString mainQmlFileName;

    QCommandLineOption forceParsing(QStringList() << "f" << "force-parsing", "Parsing config files, even cache is available");
    QCommandLineOption testingConfig(QStringList() << "t" << "testing-mode", "Run the application with with testing mode configs");

    cmdLnParser.addOption(forceParsing);
    cmdLnParser.addOption(testingConfig);

    cmdLnParser.process(app);

    bool is_testing_mode = cmdLnParser.isSet(testingConfig);
    bool is_forced = is_testing_mode || cmdLnParser.isSet(forceParsing);



    if (is_testing_mode)
    {
       mainQmlFileName = "tests.qml";
    }
    else
    {
        mainQmlFileName = "main.qml";
    }



    if (is_testing_mode)
    {
        AMJsonConfigReader::getInstance()->readJsonDocument("signals/ME_Test_Signals.json");
    }
    else
    {
        AMJsonConfigReader::getInstance()->readJsonDocument("signals/EW8_Signals.json");
    }









    if (is_forced)
    {
        CanRxMsg::forceDBCParsing();
    }


    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();
    EWInfo::declareQML();

    QQmlApplicationEngine engine;

    QUrl mainQmlUrl;


    if (!is_forced && QResource::registerResource((QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.rcc"))))
    {
         engine.addImportPath(":/");
         mainQmlUrl = QUrl(QStringLiteral("qrc:/")+mainQmlFileName);
    }
    else
    {
        mainQmlUrl = QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/")+mainQmlFileName);
    }

    QQmlComponent component(&engine, mainQmlUrl);


    QObject * componentObject = component.create();

    qDebug() << "Component created, time" << bootUpTimer.elapsed();

    MainProcess* mp = MainProcess::getInstance(componentObject);

#ifndef REMOVE_EW8_HW
    mp->setBrightnessControl(& brightnessControl);
#endif
    if (!is_testing_mode)
    {
        CanRxMsg::saveToStorage();
    }

    qDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();

    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time:" << bootUpTimer.elapsed();




#ifdef LOG_INIT_COMPLETE_TO_DMESG


    if ( ! is_testing_mode)
    {
        if (kernMsgDev.open(QFile::WriteOnly | QFile::Text))
        {
           kernMsgDev.write("<2> canquick: in main loop");
           kernMsgDev.close();
        }
    }

#endif

#ifndef WIN32

    if ( ! is_testing_mode)
    {
        system("killall -USR2 ew8_splash");
    }

#endif

    return app.exec();
}
