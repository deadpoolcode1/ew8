#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"

SimpleCanRxMsg::SimpleCanRxMsg()
{
   cid = can_id_undefined;
}

void SimpleCanRxMsg::ack()
{
    /*skip*/
}
