#include "seeqtimeinfocanrxmsg.h"
#include "defs.h"

#include "canrxmsg.h"
#include "simplecanrxmsg.h"

#include "amsignalsmodel.h"
#include "amjsonprotocol.h"
#include "candbsignal.h"

#include "qquickqrcode.h"

SeeQTimeInfoCanRxMsg::SeeQTimeInfoCanRxMsg()
{
  setCanID(can_id_cq_time_info);
}

void SeeQTimeInfoCanRxMsg::process(struct can_frame * frame)
{

    //Extract Fields Block
    canRxJsonSignalsParseAndProcess(frame);
    //End of extract fields block
}

