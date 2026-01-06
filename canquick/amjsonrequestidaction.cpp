#include "amjsonrequestidaction.h"
#include "canrxmsg.h"
#include "core/core.h"
#include <QObject>

class CanRxMsg;

AMJsonRequestIdAction::AMJsonRequestIdAction(AMJsonProtocol * aJsonProtocol, String action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, RequestId, action, parent)
{
    itsIndex = 0;
}


void AMJsonRequestIdAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    bool status;
       coreDebug() << "RequestId byte: " <<itsIndex << ":" << (void*)((int32_t)extractedCANsignal.toInt(&status));

       if(itsIndex == 0)
       {
           CanRxMsg::receiveRequestIdByteLSB((uint8_t)extractedCANsignal.toInt(&status));
       }

       if(itsIndex == 1)
       {
           CanRxMsg::receiveRequestIdByteMSB((uint8_t)extractedCANsignal.toInt(&status));
       }
}

