#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "canrxmsg.h"
#include <QMultiMap>
#include <QObject>

class AMJsonSignal;

class AMJsonProtocol : public QObject
{
   Q_OBJECT

public:

    enum protocol_type_e
    {
         GPIO = 1,
         CAN = 2,
    };
    Q_ENUM(protocol_type_e)

    explicit AMJsonProtocol(QString aName, QObject * parent = nullptr);

    void append(AMJsonSignal * signal);

    QString getName(void);

    QList<AMJsonSignal*> getSignalEntries(QString aName);

    void setType(QJsonValue typeValue);
    protocol_type_e getType(void);
    QString getTypeQString(void);

     bool getIsEnabled(void){return is_enabled;}

public slots:

    void enableDisableThis(bool OnOff);

private:
    QString name;
    protocol_type_e type;

    bool is_enabled;

    QMultiMap<QString,AMJsonSignal*> jsonSignals;


};

#endif // AMJSONPROTOCOL_H
