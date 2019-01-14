#ifndef ALERTTYPES_H
#define ALERTTYPES_H

#include <QtGlobal>

#include <QObject>

#include <QQmlEngine>

class AlertTypes : public QObject
{

    Q_OBJECT

public:
    explicit AlertTypes(QObject *parent = nullptr): QObject(parent){}

    enum EnAlert
    {
        QtQG = 0,  // group


        //Alert Items:
        ALERT_NONE = 1,

        //Smart Items:
        SMART_BASE   = 2,
        SMART_ANIMAL = SMART_BASE + 1,
        SMART_SEV_WEATHER = SMART_BASE + 2,
        SMART_SLIPPERY = SMART_BASE + 3,

        //Special Item:
         ALERT_END_OF_TYPE,
    };
    Q_ENUMS(EnAlert)


    // Do not forget to declare your class to the QML system.

    static void declareQML() {
                qmlRegisterType<AlertTypes>("MyQMLenums",0, 1, "Alert");
            }

signals:

public slots:
};

#endif // ALERTTYPES_H
