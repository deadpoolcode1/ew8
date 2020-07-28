#ifndef ALERTTYPES_H
#define ALERTTYPES_H

#include <QtGlobal>

#include <QObject>

#include <QQmlEngine>

//TODO try convert to Q_GADGET
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
        ALERT_NOCOM = 2,
        ALERT_REQFAIL = 3,

        //Smart Items:
        SMART_BASE   = 4,
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
