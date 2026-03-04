#ifndef AMJSONACTIONSMULTIPLEXOR_H
#define AMJSONACTIONSMULTIPLEXOR_H


#include "defs.h"
#include "core/types.h"
#include "core/json.h"
#include "amjsonaction.h"
#include "amjsonsignal.h"
#include "iamjsonactionfactory.h"
#include "iamjsonprocessable.h"

class AMJsonAction;
class AMJsonSignal;
class IAMJsonActionFactory;

class AmJsonActionsMultiplexor
{
public:

    AmJsonActionsMultiplexor(AMJsonProtocol * aProtocol, core::JsonArray vt_rows, const String& type);

    std::unordered_map<double, IAMJsonProcessable *> * getItsValueTable();

    int32_t getItsValuesType(void);

private:
    action_type_e  type;
    core::JsonArray itsRawRows;
    std::unordered_map<double, IAMJsonProcessable *> itsValueTable;
    void initByType(const String& aType);

    AMJsonProtocol * itsProtocol;
    IAMJsonActionFactory * itsActionFactory;

};

#endif // AMJSONACTIONSMULTIPLEXOR_H
