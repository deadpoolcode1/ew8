#ifndef ALERTTYPES_H
#define ALERTTYPES_H

// Include Qt workarounds before any Qt headers
#include "qt_workarounds.h"

#include <QtGlobal>

#include <QObject>

#include <QQmlEngine>

//TODO try convert to Q_GADGET
class AlertTypes : public QObject
{

    Q_OBJECT
    Q_PROPERTY(int QtQG READ getQtQG CONSTANT)
    Q_PROPERTY(int ALERT_NONE READ getAlertNone CONSTANT)
    Q_PROPERTY(int ALERT_NOCOM READ getAlertNocom CONSTANT)
    Q_PROPERTY(int ALERT_REQFAIL READ getAlertReqfail CONSTANT)
    Q_PROPERTY(int ALERT_END_OF_TYPE READ getAlertEndOfType CONSTANT)

public:
    explicit AlertTypes(QObject *parent = nullptr): QObject(parent){}

    enum EnAlert
    {
        QtQG = 0,  // group


        //Alert Items:
        ALERT_NONE = 1,
        ALERT_NOCOM = 2,
        ALERT_REQFAIL = 3,

        //Special Item:
         ALERT_END_OF_TYPE,
    };
    Q_ENUM(EnAlert)

    // Property getters for QML access
    int getQtQG() const { return QtQG; }
    int getAlertNone() const { return ALERT_NONE; }
    int getAlertNocom() const { return ALERT_NOCOM; }
    int getAlertReqfail() const { return ALERT_REQFAIL; }
    int getAlertEndOfType() const { return ALERT_END_OF_TYPE; }

    // Do not forget to declare your class to the QML system.

    static void declareQML() {
                qmlRegisterType<AlertTypes>("MyQMLenums",0, 1, "Alert");
            }

signals:

public slots:
};

#endif // ALERTTYPES_H
