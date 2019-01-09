

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

CanRxMsg * CanRxMsgFactory::createCanRxMsgInstance(can_id_t cid, AMSignalsModel * model)
{
    CanRxMsg * ret = nullptr;

    switch (cid)
    {
    case can_id_master:

        ret =  new AwsCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("Aftermarket"));

        break;

    case can_id_tsr:

        ret = new TsrCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("Aftermarket_TSR"));

        break;

    case can_id_s_adas:

        ret = new SmartCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("SmartADAS"));

        break;

    case can_id_cq_system_info:

        ret = new SeeQSysInfoCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("SeeQInfo"));

        break;

    case can_id_cq_time_info:

        ret = new SeeQTimeInfoCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("SeeQInfo"));

        break;

    default:

        /* skip */

        break;
    }

    return ret;
}
