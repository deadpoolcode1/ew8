#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"
#include "alerttypes.h"

#include <queue>

//using namespace AlertTypes;

void qutest();

int main(int argc, char *argv[])
{

    qutest();

    AlertTypes::declareQML();


    AlertTypes::EnAlert myalert = AlertTypes::ALERT_FCW;







    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);




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

void qutest()
{
    std::queue<int> qu;

    qu.push(5);



}
