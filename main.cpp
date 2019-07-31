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

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
    AlertTypes::declareQML();
    QQuickQRCode::declareQML();

    QQmlApplicationEngine engine;

    QQmlComponent component(&engine, QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml")));
    QObject * componentObject = component.create();

    MainProcess* mp = MainProcess::getInstance(componentObject);

    mp->launchEverything();

    return app.exec();
}
