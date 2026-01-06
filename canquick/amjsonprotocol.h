#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "amjsonactionsmultiplexor.h"
#include "canrxmsg.h"
#include "core/json.h"
#include "core/types.h"
#include <QObject>

class AMJsonSignal;
class AmJsonActionsMultiplexor;
class IAMJsonEnablable;

class AMJsonProtocol : public QObject
{
   Q_OBJECT

public:

    enum protocol_type_e
    {
         GPIO = 1,
         CAN = 2,
         Disabled = 3,
    };
    Q_ENUM(protocol_type_e)


    explicit AMJsonProtocol(AMSignalsModel * aModel, core::JsonValue protocolNameAndType, QObject * parent = nullptr);

    void append(AMJsonSignal * signal);

    core::QString getName(void);

    core::QList<AMJsonSignal*> getSignalEntries(core::QString aName);

    void setType(core::JsonValue typeValue);
    protocol_type_e getType(void);
    core::QString getTypeQString(void);

     bool getIsEnabled(void) {return disablers.isEmpty();}

     AMSignalsModel * itsModel;

     void collectValueTables(core::JsonValue protocolValueTables);

     //NOTE: fails when name already exists
     bool addMultiplexor(core::QString name, AmJsonActionsMultiplexor * mux);

     //NOTE: returns nullptr when lacks name or different type already assigned
     AmJsonActionsMultiplexor * getMultiplexorByName(core::QString name);

public slots:

    void enableDisableThis(bool OnOff);

private:
    core::QString name;
    core::QString ackProtName;

    protocol_type_e type;

    core::QList<QObject *> disablers;

    core::QMultiMap<core::QString,AMJsonSignal*> jsonSignals;

    core::QMap<core::QString, AmJsonActionsMultiplexor*> jsonMultiplexors;

    uint32_t poolIndex;
    static core::QMap<uint32_t, AMJsonProtocol *> objectsPool;

};

#endif // AMJSONPROTOCOL_H
