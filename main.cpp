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


class AlertTypes;
class QQuickQRCode;

QElapsedTimer bootUpTimer;

int main(int argc, char *argv[])
{
    bootUpTimer.start();

    qDebug() << "Initialization begins, time" << bootUpTimer.elapsed();

#if 0
    qDebug() << "Supported Animated Formats" << QImageReader::supportedImageFormats();
#endif


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QCoreApplication coreApp(argc,argv);

    QGuiApplication * app;


#if 0
    QPixmap pixmap("/opt/canquick/qml/images/logo/ME_logo_app_splash.png");
    QSplashScreen splash(pixmap);
    splash.show();
#endif

    QCommandLineParser cmdLnParser;

    QCommandLineOption forceParsing(QStringList() << "f" << "force-parsing", "Parsing config files, even cache is available");

    QCommandLineOption splashPid(QStringList() << "s" << "splash-screen-pid", "Wait for splash screen process to finish or kill it","splash_pid");

    cmdLnParser.addOption(forceParsing);

    cmdLnParser.addOption(splashPid);

    cmdLnParser.process(coreApp);

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

    bool is_splashed = cmdLnParser.isSet(splashPid);

    QString splash_pid;

    if(is_splashed)
    {
        splash_pid = cmdLnParser.value(splashPid);
        qDebug() << "Splash pid:" << splash_pid;
    }

    if(is_splashed)
    {
#ifndef WIN32
        QDir proc("/proc");

        while(proc.exists(splash_pid))
        {
            QThread::msleep(100);
        }
#endif
    }

    app = new QGuiApplication(argc, argv);

    QObject * componentObject = component.create();

    qDebug() << "Component created, time" << bootUpTimer.elapsed();



    MainProcess* mp = MainProcess::getInstance(componentObject);

    CanRxMsg::saveToStorage();

    qDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();



    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time:" << bootUpTimer.elapsed();

#ifdef LOG_INIT_COMPLETE_TO_DMESG
    QFile kernMsgDev("/dev/kmsg");

    if(kernMsgDev.open(QFile::WriteOnly | QFile::Text))
    {
       kernMsgDev.write("<2> canquick: in main loop");
       kernMsgDev.close();
    }

#endif


    return app->exec();
}
