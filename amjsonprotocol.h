#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "canrxmsg.h"
#include <QMultiMap>

class AMJsonSignal;

class AMJsonProtocol
{

   Q_GADGET

public:

    enum protocol_type_e
    {
         GPIO = 1,
         CAN = 2,
    };
    Q_ENUM(protocol_type_e)

    AMJsonProtocol(QString aName);

    void append(AMJsonSignal * signal);

    QString getName(void);

    QList<AMJsonSignal> getSignalEntries(QString aName);

    void setType(QJsonValue typeValue);
    protocol_type_e getType(void);
    QString getTypeQString(void);


private:
    QString name;
    protocol_type_e type;
    QMultiMap<QString,AMJsonSignal> jsonSignals;


};

#endif // AMJSONPROTOCOL_H
