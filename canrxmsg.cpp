
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

CanRxMsg * CanRxMsg::CanRxMsgsPool[];
size_t CanRxMsg::canRxMsgNumOfObjects = 0;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;

CanRxMsg * CanRxMsg::createInstance(can_id_t cid, AMSignalsModel * model)
{
    CanRxMsg * ret = getMsgByCanId(cid);
    //TODO review the check location
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id
        ret = iCanRxMsgFactory->createCanRxMsgInstance(cid, model);


    }
    return ret;
}

void CanRxMsg::setItsJsonProtocol(AMJsonProtocol *aJsonProtocol)
{
    itsJsonProtocol = aJsonProtocol;
    initCanJsonSignalsListInProcessOrder();
}

void CanRxMsg::setDisplay(IAlertDisplay *anAlertDisplay)
{
    alertsDisplay = anAlertDisplay;
}

void CanRxMsg::initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory,IAlertDisplay *anAlertDisplay, AMSignalsModel * amSignalsModel)
{
    CanRxMsg::iCanRxMsgFactory = anICanRxMsgFactory;

    for(size_t i=0;i<CAN_MESSAGES_TYPES_NUM;i++)
    {
        if(canRxMsgNumOfObjects < CAN_MESSAGES_TYPES_NUM)
        {
            CanRxMsgsPool[canRxMsgNumOfObjects] = createInstance(can_id_values_table[i].mnemonic, amSignalsModel);
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
    setCanID(can_id_undefined);
    is_a_first_frame = true;

    itsJsonProtocol = nullptr;
}

void CanRxMsg::setCanID(can_id_t canID)
{
    cid = canID;

    if(can_id_undefined == canID)
    {
       canSignalsArray = nullptr;
       canSignalsArray_size = 0;
    }
    else
    {
        //NOTE use table
        for (size_t i = 0; i< CAN_MESSAGES_TYPES_NUM; i++)
        {
            if(canID == can_id_values_table[i].mnemonic)
            {
                canSignalsArray = can_id_values_table[i].sg_array;
                canSignalsArray_size = can_id_values_table[i].sg_array_size;
            }
        }
    }
}

can_id_t CanRxMsg::getCanID(void)
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

void CanRxMsg::initCanJsonSignalsListInProcessOrder(void)
{
    for (size_t i = 0; i < canSignalsArray_size; i++)
    {

        //JSON Driven Alerts Triggering:


        QString currSignalStr = canSignalsArray[i].name;

        //TODO single return point
        if (itsJsonProtocol)
        {

            QList<AMJsonSignal*> signalsList =  (itsJsonProtocol->getSignalEntries(currSignalStr));

            foreach (AMJsonSignal * jsonsig, signalsList)
            {
                switch(jsonsig->type)
                {
                case AMJsonSignal::Enabler:

                     canJsonSignalsListInProcessOrder.prepend(jsonsig);

                    break;

                default:

                    canJsonSignalsListInProcessOrder.append(jsonsig);

                    break;
                }

            }

        }
    }
}

