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

    String getName(void);

    List<AMJsonSignal*> getSignalEntries(const String& aName);

    void setType(core::JsonValue typeValue);
    protocol_type_e getType(void);
    String getTypeString(void);

     bool getIsEnabled(void) {return disablers.empty();}

     AMSignalsModel * itsModel;

     void collectValueTables(core::JsonValue protocolValueTables);

     //NOTE: fails when name already exists
     bool addMultiplexor(const String& name, AmJsonActionsMultiplexor * mux);

     //NOTE: returns nullptr when lacks name or different type already assigned
     AmJsonActionsMultiplexor * getMultiplexorByName(const String& name);

public slots:

    void enableDisableThis(bool OnOff);

private:
    String name;
    String ackProtName;

    protocol_type_e type;

    List<QObject *> disablers;

    QMultiMap<String,AMJsonSignal*> jsonSignals;

    QMap<String, AmJsonActionsMultiplexor*> jsonMultiplexors;

    uint32_t poolIndex;
    static QMap<uint32_t, AMJsonProtocol *> objectsPool;

};

#endif // AMJSONPROTOCOL_H
