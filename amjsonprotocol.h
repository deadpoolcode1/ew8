#ifndef AMJSONPROTOCOL_H
#define AMJSONPROTOCOL_H

#include "amjsonsignal.h"
#include "amjsonactionsmultiplexor.h"
#include "canrxmsg.h"
#include "core/json.h"
#include "core/types.h"
#include "core/enum_utils.h"
class AMJsonSignal;
class AmJsonActionsMultiplexor;
class IAMJsonEnablable;

class AMJsonProtocol
{
public:
    // protocol_type_e is defined in core/enum_utils.h

    explicit AMJsonProtocol(AMSignalsModel * aModel, core::JsonValue protocolNameAndType);

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

    void enableDisableThis(void * sender, bool OnOff);

private:
    String name;
    String ackProtName;

    protocol_type_e type;

    List<void *> disablers;

    MultiMap<String,AMJsonSignal*> jsonSignals;

    Map<String, AmJsonActionsMultiplexor*> jsonMultiplexors;

    uint32_t poolIndex;
    static Map<uint32_t, AMJsonProtocol *> objectsPool;

};

#endif // AMJSONPROTOCOL_H
