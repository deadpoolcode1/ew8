#ifndef AMJSONSYSTEMREQUESTACTION_H
#define AMJSONSYSTEMREQUESTACTION_H

#include <QObject>

#include "defs.h"

#include "amjsonaction.h"

class AMJsonAction;
class AMJsonProtocol;

class AMJsonSystemRequestAction : public AMJsonAction
{
public:
    explicit AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent = nullptr);

    //NOTE: default index value (0)
    void process(QObject * sender, QVariant extractedCANsignal);

protected:


};

#endif // AMJSONSYSTEMREQUESTACTION_H
