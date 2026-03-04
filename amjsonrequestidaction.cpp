#include "amjsonrequestidaction.h"
#include "canrxmsg.h"
#include "core/core.h"
class CanRxMsg;

AMJsonRequestIdAction::AMJsonRequestIdAction(AMJsonProtocol * aJsonProtocol, const String& action): AMJsonAction(aJsonProtocol, RequestId, action)
{
    itsIndex = 0;
}


void AMJsonRequestIdAction::process(void * /*sender*/, Variant extractedCANsignal)
{
    bool status;
       coreDebug() << "RequestId byte: " <<itsIndex << ":" << (void*)((intptr_t)variantToInt(extractedCANsignal, &status));

       if(itsIndex == 0)
       {
           CanRxMsg::receiveRequestIdByteLSB((uint8_t)variantToInt(extractedCANsignal, &status));
       }

       if(itsIndex == 1)
       {
           CanRxMsg::receiveRequestIdByteMSB((uint8_t)variantToInt(extractedCANsignal, &status));
       }
}

