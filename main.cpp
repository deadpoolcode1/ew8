#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"
#include "alerttypes.h"

int main(int argc, char *argv[])
{


    AlertTypes::declareQML();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
     AlertTypes::declareQML();

    QQmlApplicationEngine engine;

    QQmlComponent component(&engine, QUrl(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("qml/main.qml")));
    QObject * componentObject = component.create();

    MainProcess* mp = MainProcess::getInstance(componentObject);

    mp->exec();


    return app.exec();
}
