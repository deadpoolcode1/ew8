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
                ALERT_FCW,
                ALERT_PDZ,
                ALERT_PCW,
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
