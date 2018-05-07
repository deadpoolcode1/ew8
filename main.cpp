#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "mainprocess.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    MainProcess mp;

    mp.exec();


    return app.exec();
}
