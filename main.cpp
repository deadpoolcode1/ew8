#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"

#include <queue>


void qutest();

int main(int argc, char *argv[])
{

    qutest();

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
