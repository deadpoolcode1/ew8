#ifndef ALERTTYPES_H
#define ALERTTYPES_H

// Qt-free enum values and DISPLAY_ITEM_ID
#include "alerttypes_core.h"

// Include Qt workarounds before any Qt headers
#include "qt_workarounds.h"

#include <QtGlobal>
#include <QObject>
#include <QQmlEngine>

// Qt wrapper class — re-exposes AlertTypes::EnAlert for QML via Q_ENUM.
// The enum values themselves live in alerttypes_core.h (namespace AlertTypes).
// This class brings them into the QObject/QML world.
class AlertTypesQml : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int QtQG READ getQtQG CONSTANT)
    Q_PROPERTY(int ALERT_NONE READ getAlertNone CONSTANT)
    Q_PROPERTY(int ALERT_NOCOM READ getAlertNocom CONSTANT)
    Q_PROPERTY(int ALERT_REQFAIL READ getAlertReqfail CONSTANT)
    Q_PROPERTY(int ALERT_END_OF_TYPE READ getAlertEndOfType CONSTANT)

public:
    explicit AlertTypesQml(QObject *parent = nullptr): QObject(parent){}

    // Mirror the core enum so Q_ENUM can expose it to QML
    enum EnAlert
    {
        QtQG = AlertTypes::QtQG,
        ALERT_NONE = AlertTypes::ALERT_NONE,
        ALERT_NOCOM = AlertTypes::ALERT_NOCOM,
        ALERT_REQFAIL = AlertTypes::ALERT_REQFAIL,
        ALERT_END_OF_TYPE = AlertTypes::ALERT_END_OF_TYPE,
    };
    Q_ENUM(EnAlert)

    // Property getters for QML access
    int getQtQG() const { return AlertTypes::QtQG; }
    int getAlertNone() const { return AlertTypes::ALERT_NONE; }
    int getAlertNocom() const { return AlertTypes::ALERT_NOCOM; }
    int getAlertReqfail() const { return AlertTypes::ALERT_REQFAIL; }
    int getAlertEndOfType() const { return AlertTypes::ALERT_END_OF_TYPE; }

    static void declareQML() {
        qmlRegisterType<AlertTypesQml>("MyQMLenums", 0, 1, "Alert");
    }

signals:

public slots:
};

// Backward-compatible typedef so existing code using "AlertTypes::declareQML()" still compiles
// in frontend files that include this header.
// Backend files should use alerttypes_core.h directly (via defs.h) and never see this.
typedef AlertTypesQml AlertTypesQt;

#endif // ALERTTYPES_H
