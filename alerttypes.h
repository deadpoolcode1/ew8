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
        ALERT_NONE = 1,
        ALERT_FCW = 2,
        ALERT_PDZ = 3,
        ALERT_PCW = 4,
        ALERT_LDWOFF = 5,
        ALERT_LDWON = 6,
        ALERT_LLDW = 7,
        ALERT_RLDW = 8,
        ALERT_HMW0 = 9,
        ALERT_HMW1 = 10,
        ALERT_HMW2 = 11,
        ALERT_HMW3 = 12,
        ALERT_HMW4 = 13,
        ALERT_HMW5 = 14,
        ALERT_HMW6 = 15,
        ALERT_HMW7 = 16,
        ALERT_HMW8 = 17,
        ALERT_HMW9 = 18,
        ALERT_HMW10 = 19,
        ALERT_HMW11 = 20,
        ALERT_HMW12 = 21,
        ALERT_HMW13 = 22,
        ALERT_HMW14 = 23,
        ALERT_HMW15 = 24,
        ALERT_HMW_GREEN = 25,
        ALERT_HI_BEAM = 26,
        ALERT_LOW_BEAM = 27,
        ALERT_BLINKERS = 28,
        ALERT_REGULAR = 29,
        ALERT_FORWARD = 30,
        ALERT_END_OF_TYPE = 31
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
