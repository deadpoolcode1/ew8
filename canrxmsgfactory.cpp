

//NOTE: add all types of CanRxMsg:
#include "defs.h"
#include "canrxmsg.h"
#include "smartcanrxmsg.h"
#include "simplecanrxmsg.h"
#include "canrxmsgfactory.h"
#include "icanrxmsgfactory.h"

CanRxMsg * CanRxMsgFactory::createCanRxMsgInstance(CanStdId_t StdId, AMSignalsModel * model)
{
    CanRxMsg * ret = nullptr;

    canrxmsg_type_t type = msg_simple;

    for(size_t i = 0; i < CAN_MESSAGES_TYPES_NUM; i++)
    {
        if(can_msg_types_table[i].std_id == StdId)
        {
            type = can_msg_types_table[i].type;
            i = CAN_MESSAGES_TYPES_NUM;
        }
    }

    switch (type)
    {
    case msg_simple:

        ret =  new SimpleCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("Aftermarket"));

        break;


    case msg_smart:

        ret = new SmartCanRxMsg();
        ret->setItsJsonProtocol(model->getProtocol("SmartADAS"));

        break;


    default:

        /* skip */

        break;
    }

    return ret;
}
