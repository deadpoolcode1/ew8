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
                ALERT_END_OF_TYPE = 9,
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
