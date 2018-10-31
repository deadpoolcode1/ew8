
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

CanRxMsg * CanRxMsg::CanRxMsgsPool[];
size_t CanRxMsg::canRxMsgNumOfObjects = 0;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;

CanRxMsg * CanRxMsg::createInstance(can_id_t cid)
{
    CanRxMsg * ret = getMsgByCanId(cid);
    //TODO review the check location
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id
        ret = iCanRxMsgFactory->createCanRxMsgInstance(cid);


    }
    return ret;
}

void CanRxMsg::setDisplay(IAlertDisplay *anAlertDisplay)
{
    alertsDisplay = anAlertDisplay;
}

void CanRxMsg::initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory,IAlertDisplay *anAlertDisplay)
{
    CanRxMsg::iCanRxMsgFactory = anICanRxMsgFactory;

    for(size_t i=0;i<CAN_MESSAGES_TYPES_NUM;i++)
    {
        if(canRxMsgNumOfObjects < CAN_MESSAGES_TYPES_NUM)
        {
            CanRxMsgsPool[canRxMsgNumOfObjects] = createInstance(can_id_values_table[i].mnemonic);
            if(nullptr != CanRxMsgsPool[canRxMsgNumOfObjects])
            {
                CanRxMsgsPool[canRxMsgNumOfObjects]->setDisplay(anAlertDisplay);
                canRxMsgNumOfObjects++;
            }
        }
    }

}

CanRxMsg::CanRxMsg()
{
    cid = can_id_undefined;
    is_a_first_frame = true;
}

can_id_t CanRxMsg::getCanId(void)
{
    return cid;
}

CanRxMsg * CanRxMsg::getMsgByCanId(can_id_t cid)
{
    CanRxMsg * ret = nullptr;
    for (size_t i=0; i < canRxMsgNumOfObjects; i++)
    {
        if (cid == CanRxMsgsPool[i]->cid)
        {
            ret = CanRxMsgsPool[i];
            i = canRxMsgNumOfObjects;
        }
    }
    return ret;
}

