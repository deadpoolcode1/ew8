#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QElapsedTimer>

#include "qquickqrcode.h"

#include "mainprocess.h"
#include "alerttypes.h"

#include "amjsonsignal.h"

#include "defs.h"

class AlertTypes;
class QQuickQRCode;

int main(int argc, char *argv[])
{
    QElapsedTimer timer;

    timer.start();

    qDebug() << "Initialization begins, time" << timer.elapsed();


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();

    QQmlApplicationEngine engine;

    QQmlComponent component(&engine, QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml")));
    QObject * componentObject = component.create();

    MainProcess* mp = MainProcess::getInstance(componentObject);

    qDebug() << "Initialization complete, time:" << timer.elapsed();

    mp->launchEverything();

    qDebug() << "Core Application Loop begins, time" << timer.elapsed();

    return app.exec();
}
