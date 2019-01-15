#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "tsrcanrxmsg.h"


TsrCanRxMsg::TsrCanRxMsg()
{
    setCanID(can_id_tsr);
}

void TsrCanRxMsg::process(struct can_frame * frame)
{  
       //Extract Fields Block

       canRxJsonSignalsParseAndProcess(frame);

       //End of extract fields block

       qDebug("AWS Can Rx Msg with new info processed @%s:%d", __func__, __LINE__);
}




