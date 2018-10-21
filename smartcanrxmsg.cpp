#include "canrxmsg.h"
#include "smartcanrxmsg.h"

SmartCanRxMsg::SmartCanRxMsg()
{
    cid = can_id_s_adas;
}

void SmartCanRxMsg::process(struct can_frame * frame)
{

}

void SmartCanRxMsg::ack()
{


}


