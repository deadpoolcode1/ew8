

//NOTE: add all types of CanRxMsg:
#include "defs.h"
#include "canrxmsg.h"
#include "canrxmsgfactory.h"
#include "icanrxmsgfactory.h"

#if (HARDCODED_CAN_MESSAGES_TYPES_NUM == 0)
CanRxMsg * CanRxMsgFactory::createCanRxMsgInstance(CanStdId_t)
#else
CanRxMsg * CanRxMsgFactory::createCanRxMsgInstance(CanStdId_t StdId)
#endif
{
    CanRxMsg * ret = nullptr;

#if (HARDCODED_CAN_MESSAGES_TYPES_NUM == 0)
    ret =  new CanRxMsg();
#else
    canrxmsg_type_t type = msg_simple;

    for(size_t i = 0; i < HARDCODED_CAN_MESSAGES_TYPES_NUM; i++)
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

        ret =  new CanRxMsg();

        break;


    //NOTE: hardcoded messages mechanism
    case msg_smart:

        ret = new SmartCanRxMsg();

        break;


    default:

        /* skip */

        break;
    }
#endif

    return ret;
}
