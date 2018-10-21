#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "awscanrxmsg.h"

AwsCanRxMsg::AwsCanRxMsg()
{
    cid = can_id_master;
}

void AwsCanRxMsg::process(struct can_frame * frame)
{
#if 0
    printf("parse aws\n");
#endif
}
