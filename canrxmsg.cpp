
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

CanRxMsg * CanRxMsg::CanRxMsgsPool[];
size_t CanRxMsg::CanRxMsgNumOfObjects = 0;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;

CanRxMsg * CanRxMsg::createInstance(can_id_t cid)
{
    CanRxMsg * ret = getMsgByCanId(cid);
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id

    }
    return ret;
}

void CanRxMsg::initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory)
{
    CanRxMsg::iCanRxMsgFactory = anICanRxMsgFactory;
}

CanRxMsg::CanRxMsg()
{
    cid = can_id_undefined;
}

can_id_t CanRxMsg::getCanId(void)
{
    return cid;
}

CanRxMsg * CanRxMsg::getMsgByCanId(can_id_t cid)
{
    CanRxMsg * ret = nullptr;
    for (size_t i=0; i < CanRxMsgNumOfObjects; i++)
    {
        if (cid == CanRxMsgsPool[i]->cid)
        {
            ret = CanRxMsgsPool[i];
            i = CanRxMsgNumOfObjects;
        }
    }
    return ret;
}

