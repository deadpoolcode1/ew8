#ifndef AMJSONARGUMENTACTION_H
#define AMJSONARGUMENTACTION_H

#include "defs.h"
#include "core/types.h"

#include "amjsonaction.h"

class AMJsonAction;
class AMJsonProtocol;

class AMJsonArgumentAction : public AMJsonAction
{
public:
    explicit AMJsonArgumentAction(AMJsonProtocol * aJsonProtocol, action_type_e type, const String& action);

    //NOTE: default index value (0)
    void setIndex(ssize_t anIndex) {itsIndex = anIndex;}

    virtual bool isItsArgumentsType(int32_t type) = 0;

    virtual void process(void * sender, Variant extractedCANsignal) = 0;

protected:

    DISPLAY_ITEM_ID itsGraphicItemID;
    ssize_t itsIndex;

};

#endif // AMJSONARGUMENTACTION_H
