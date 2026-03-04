#ifndef AMJSONSYSTEMREQUESTACTION_H
#define AMJSONSYSTEMREQUESTACTION_H

#include "defs.h"
#include "sysreqtype.h"
#include "core/types.h"

#include "amjsonaction.h"


class AMJsonAction;
class AMJsonProtocol;
class SystemRequestType;

class AMJsonSystemRequestAction : public AMJsonAction
{
public:
    explicit AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, const String& action);

    //NOTE: default index value (0)
    void process(void * sender, Variant extractedCANsignal);

private:

    sysreq_type_e type;

protected:


};

#endif // AMJSONSYSTEMREQUESTACTION_H
