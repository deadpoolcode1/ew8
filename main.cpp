#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>

#include "mainprocess.h"
#include "alerttypes.h"

#include <queue>


void qutest();


int main(int argc, char *argv[])
{

    qutest();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

#if 0
 // Register qml enum
    qmlRegisterUncreatableMetaObject(
          AlertTypes::staticMetaObject, // static meta object
          "my.namespace",                // import statement (can be any string)
          1, 0,                          // major and minor version of the import
          "AlertTypes",                 // name in QML (does not have to match C++ name)
          "Error: only enums"            // error in case someone tries to create an object
        );

#endif

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

void qutest()
{
    std::queue<int> qu;

    qu.push(5);



}
