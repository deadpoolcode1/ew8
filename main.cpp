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
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
    {
        return -1;
    }

    MainProcess* mp = MainProcess::getInstance(&engine);

    mp->exec();


    return app.exec();
}
