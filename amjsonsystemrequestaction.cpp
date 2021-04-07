#include "sysreqtype.h"
#include "brightnesscontrol.h"
#include "amjsonsystemrequestaction.h"
#include "canrxmsg.h"
#include "versionmsg.h"
#include <QDebug>
#include <QObject>

class VersionMsg;
class SystemRequestType;
class BrightnessControl;

AMJsonSystemRequestAction::AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, SystemRequest, action, parent)
{
   type = SystemRequestType::fromString(action);
}


void AMJsonSystemRequestAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    switch (type)
    {
    case GetVersion:

    if (extractedCANsignal.toBool())
    {
        VersionMsg::singleShot();
    }
        break;

    case DebugBrightness:
        BrightnessControl::setCANDebugReport(extractedCANsignal.toBool());
                break;
    default:
        qDebug()<<"Processing unsupported request type";
        break;
    }
}

