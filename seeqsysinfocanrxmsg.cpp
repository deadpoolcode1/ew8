#include "seeqsysinfocanrxmsg.h"
#include "defs.h"

#include "canrxmsg.h"
#include "simplecanrxmsg.h"

#include "amsignalsmodel.h"
#include "amjsonprotocol.h"
#include "candbsignal.h"

#include "qquickqrcode.h"

SeeQSysInfoCanRxMsg::SeeQSysInfoCanRxMsg()
{
  setCanID(can_id_cq_system_info);
  itsJsonProtocol =  AMSignalsModel::getInstance()->getProtocol("SeeQInfo");
}

void SeeQSysInfoCanRxMsg::process(struct can_frame * frame)
{ 
    //Extract Fields Block
    canRxJsonSignalsParseAndProcess(frame);
    //End of extract fields block
}

