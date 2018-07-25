#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"
#include "alerttypes.h"

//#include <queue>


int main(int argc, char *argv[])
{

    qutest();

    AlertTypes::declareQML();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Usage of QML enum in C++:
     AlertTypes::declareQML();

     AlertTypes::EnAlert enAlert = AlertTypes::ALERT_FCW;
     //////////////////////////////




    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
    {
        return -1;
    }

    MainProcess mp(&engine);

    mp.exec();


    return app.exec();
}
