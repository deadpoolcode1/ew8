#ifndef AMJSONACTION_H
#define AMJSONACTION_H

#include "core/types.h"
#include "actiontype.h"
#include "iamjsonprocessable.h"

class AMJsonProtocol;

class AMJsonAction : public IAMJsonProcessable
{
public:
    explicit AMJsonAction(AMJsonProtocol * aJsonProtocol, action_type_e type, const String& action);

    AMJsonProtocol * getItsJsonProtocol(void);

    String getActionName(void);

    virtual void process(void * sender, Variant extractedCANsignal) = 0;
    bool setSupplimentary(Variant extractedCANsignal);

    action_type_e getActionType(void);

private:

    String action;

    AMJsonProtocol * itsProtocol;

    uint32_t poolIndex;
    action_type_e type;
    static Map<uint32_t, AMJsonAction *> objectsPool;
};

#endif // AMJSONACTION_H
