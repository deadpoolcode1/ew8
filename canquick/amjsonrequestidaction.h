#ifndef AMJSONREQUESTIDACTION_H
#define AMJSONREQUESTIDACTION_H

#include "core/types.h"
#include <QObject>

#include "defs.h"

#include "amjsonaction.h"

class AMJsonAction;
class AMJsonProtocol;

class AMJsonRequestIdAction : public AMJsonAction
{
public:
    explicit AMJsonRequestIdAction(AMJsonProtocol * aJsonProtocol, core::QString action, AMJsonAction * parent = nullptr);

    //NOTE: default index value (0)
    void setIndex(ssize_t anIndex) {itsIndex = anIndex;}

    void process(QObject * sender, core::QVariant extractedCANsignal);

protected:

    ssize_t itsIndex;

};

#endif // AMJSONREQUESTIDACTION_H
