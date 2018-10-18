#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "tsrcanrxmsg.h"

TsrCanRxMsg::TsrCanRxMsg()
{
    cid = can_id_tsr;
}

void TsrCanRxMsg::process(struct can_frame * frame)
{
  printf("parse tsr\n");
}

