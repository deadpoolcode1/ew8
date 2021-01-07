#include "amjsonsystemrequestaction.h"
#include "canrxmsg.h"
#include "versionmsg.h"
#include <QDebug>
#include <QObject>

class VersionMsg;

AMJsonSystemRequestAction::AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, SystemRequest, action, parent)
{

}


void AMJsonSystemRequestAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    if (extractedCANsignal.toBool())
    {
        VersionMsg::singleShot();
    }
}

