#include "amjsonrequestidaction.h"
#include "canrxmsg.h"
#include "core/core.h"
#include <QObject>

class CanRxMsg;

AMJsonRequestIdAction::AMJsonRequestIdAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, RequestId, action, parent)
{
    itsIndex = 0;
}


void AMJsonRequestIdAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    bool status;
       coreDebug() << "RequestId byte: " <<itsIndex << ":" << (void*)((qint32)extractedCANsignal.toInt(&status));

       if(itsIndex == 0)
       {
           CanRxMsg::receiveRequestIdByteLSB((quint8)extractedCANsignal.toInt(&status));
       }

       if(itsIndex == 1)
       {
           CanRxMsg::receiveRequestIdByteMSB((quint8)extractedCANsignal.toInt(&status));
       }
}

