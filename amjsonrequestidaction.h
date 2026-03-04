#ifndef AMJSONREQUESTIDACTION_H
#define AMJSONREQUESTIDACTION_H

#include "defs.h"
#include "core/types.h"

#include "amjsonaction.h"

class AMJsonAction;
class AMJsonProtocol;

class AMJsonRequestIdAction : public AMJsonAction
{
public:
    explicit AMJsonRequestIdAction(AMJsonProtocol * aJsonProtocol, const String& action);

    //NOTE: default index value (0)
    void setIndex(ssize_t anIndex) {itsIndex = anIndex;}

    void process(void * sender, Variant extractedCANsignal);

protected:

    ssize_t itsIndex;

};

#endif // AMJSONREQUESTIDACTION_H
