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
                ALERT_NONE = 0,
                ALERT_FCW = 1,
                ALERT_PDZ = 2,
                ALERT_PCW = 3,
                ALERT_END_OF_TYPE = 4,
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
