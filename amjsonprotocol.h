#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "amjsonactionsmultiplexor.h"
#include "canrxmsg.h"
#include <QMultiMap>
#include <QObject>

class AMJsonSignal;
class AmJsonActionsMultiplexor;

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


    explicit AMJsonProtocol(AMSignalsModel * aModel, QJsonValue protocolNameAndType, QObject * parent = nullptr);

    void append(AMJsonSignal * signal);

    QString getName(void);

    QList<AMJsonSignal*> getSignalEntries(QString aName);

    void setType(QJsonValue typeValue);
    protocol_type_e getType(void);
    QString getTypeQString(void);

     bool getIsEnabled(void) {return disablers.isEmpty();}

     AMSignalsModel * itsModel;

     void collectValueTables(QJsonValue protocolValueTables);

     //NOTE: fails when name already exists
     bool addMultiplexor(QString name, AmJsonActionsMultiplexor * mux);

     //NOTE: returns nullptr when lacks name or different type already assigned
     AmJsonActionsMultiplexor * getMultiplexorByName(QString name);

public slots:

    void enableDisableThis(bool OnOff);

private:
    QString name;
    protocol_type_e type;

    QList<QObject *> disablers;

    QMultiMap<QString,AMJsonSignal*> jsonSignals;

    QMap<QString, AmJsonActionsMultiplexor*> jsonMultiplexors;

};

#endif // AMJSONPROTOCOL_H
