#ifndef AMJSONSYSTEMREQUESTACTION_H
#define AMJSONSYSTEMREQUESTACTION_H

#include "core/types.h"
#include <QObject>

#include "defs.h"
#include "sysreqtype.h"

#include "amjsonaction.h"


class AMJsonAction;
class AMJsonProtocol;
class SystemRequestType;

class AMJsonSystemRequestAction : public AMJsonAction
{
public:
    explicit AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, core::QString action, AMJsonAction * parent = nullptr);

    //NOTE: default index value (0)
    void process(QObject * sender, core::QVariant extractedCANsignal);

private:

    sysreq_type_e type;

protected:


};

#endif // AMJSONSYSTEMREQUESTACTION_H
