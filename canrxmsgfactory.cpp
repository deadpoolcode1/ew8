

//NOTE: add all types of CanRxMsg:
#include "defs.h"
#include "canrxmsg.h"
#include "smartcanrxmsg.h"
#include "awscanrxmsg.h"
#include "tsrcanrxmsg.h"
#include "seeqsysinfocanrxmsg.h"
#include "seeqtimeinfocanrxmsg.h"

#include "canrxmsgfactory.h"
#include "icanrxmsgfactory.h"

CanRxMsg * CanRxMsgFactory::createCanRxMsgInstance(can_id_t cid)
{
    CanRxMsg * ret = nullptr;

    switch (cid)
    {
    case can_id_master:

        ret =  new AwsCanRxMsg();

        break;

    case can_id_tsr:

        ret = new TsrCanRxMsg();

        break;

    case can_id_s_adas:

        ret = new SmartCanRxMsg();

        break;

    case can_id_cq_system_info:

        ret = new SeeQSysInfoCanRxMsg();

        break;

    case can_id_cq_time_info:

        ret = new SeeQTimeInfoCanRxMsg();

        break;

    default:

        /* skip */

        break;
    }

    return ret;
}
