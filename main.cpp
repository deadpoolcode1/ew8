#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "qquickqrcode.h"

#include "mainprocess.h"
#include "alerttypes.h"

#include "amjsonsignal.h"

#include "defs.h"

class AlertTypes;
class QQuickQRCode;

QElapsedTimer bootUpTimer;

int main(int argc, char *argv[])
{
    bootUpTimer.start();

    qDebug() << "Initialization begins, time" << bootUpTimer.elapsed();


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();

    QQmlApplicationEngine engine;

    QQmlComponent component(&engine, QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml")));
    QObject * componentObject = component.create();

    qDebug() << "Component created, time" << bootUpTimer.elapsed();

    MainProcess* mp = MainProcess::getInstance(componentObject);

    qDebug() << "Initialization complete, time:" << bootUpTimer.elapsed();

    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time" << bootUpTimer.elapsed();

    return app.exec();
}
