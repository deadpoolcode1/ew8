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

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();

    QQmlApplicationEngine engine;

    QUrl mainQmlUrl;


    //TODO: check if main.rcc exists and register
    if(QResource::registerResource((QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.rcc"))))
    {
         engine.addImportPath(":/");
         mainQmlUrl = QUrl(QStringLiteral("qrc:/main.qml"));
    }
    else
    {
        mainQmlUrl = QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml"));
    }




    QQmlComponent component(&engine, mainQmlUrl);


    //Otherwize use external main.qml


    QObject * componentObject = component.create();

    qDebug() << "Component created, time" << bootUpTimer.elapsed();

    MainProcess* mp = MainProcess::getInstance(componentObject);



    CanRxMsg::saveToStorage();

    qDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();

    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time" << bootUpTimer.elapsed();

#ifdef LOG_INIT_COMPLETE_TO_DMESG
    QFile kernMsgDev("/dev/kmsg");

    if(kernMsgDev.open(QFile::WriteOnly | QFile::Text))
    {
       kernMsgDev.write("<2> canquick: in main loop");
       kernMsgDev.close();
    }

#endif


    return app.exec();
}
