#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QQmlComponent component(&engine, "qrc:/main.qml");
    QObject *object = component.create();
    QObject * objImage = object->findChild<QObject *>("objAlert");

    if(objImage)
    {
       objImage->setProperty("source",QStringLiteral("qrc:/resources/sp_yellow_h.png"));
    }

    if (engine.rootObjects().isEmpty())
    {
        return -1;
    }

    MainProcess mp(&engine);

    mp.exec();


    return app.exec();
}
