
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

QMap <quint32, CanRxMsg *> CanRxMsg::CanRxMsgsPool;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;
AMSignalsModel * CanRxMsg::itsAMSignalsModel = nullptr;

CanRxMsg * CanRxMsg::createInstance(quint32 StdId)
{
    CanRxMsg * ret = getMsgByCanId(StdId);
    //TODO review the check location
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id
        ret = iCanRxMsgFactory->createCanRxMsgInstance(StdId, itsAMSignalsModel);
        if(nullptr != ret)
        {
            CanRxMsgsPool.insert(StdId, ret);
        }
    }
    return ret;
}

void CanRxMsg::setItsJsonProtocol(AMJsonProtocol *aJsonProtocol)
{
    itsJsonProtocol = aJsonProtocol;
    initCanJsonSignalsListInProcessOrder();
}

Signal * CanRxMsg::getCANSignalByName(QString name)
{
    Signal * ret = nullptr;

    foreach (Signal * cansig, * canSignalsArray)
    {
        if (cansig->name == name)
        {
            ret = cansig;
        }
    }

    return ret;

}

void CanRxMsg::initCanRxMsgsPool(ICanRxMsgFactory * anICanRxMsgFactory, AMSignalsModel * amSignalsModel)
{

    CanRxMsg::iCanRxMsgFactory = anICanRxMsgFactory;
    CanRxMsg::itsAMSignalsModel = amSignalsModel;

    qDebug("CanRxMsgsPool is ready for usage");
}

void CanRxMsg::completeInitCanRxMsgsPool(void)
{
    foreach (CanRxMsg * msg, CanRxMsgsPool.values())
    {
        if (msg->itsJsonProtocol)
        {
            msg->initCanJsonSignalsListInProcessOrder();
        }
    }
}

CanRxMsg::CanRxMsg()
{
    itsJsonProtocol = nullptr;
}

void CanRxMsg::applyCanDBSignalsArray(QList<Signal *> * signalsList)
{
    //canSignalsArray =  new QList<Signal *>();

    canSignalsArray = signalsList;

    qDebug ("Added signal list to the message");
}

CanRxMsg * CanRxMsg::getMsgByCanId(quint32 StdId)
{
    CanRxMsg * ret = nullptr;

    ret = CanRxMsgsPool.value(StdId, nullptr);

    return ret;
}

void CanRxMsg::initCanJsonSignalsListInProcessOrder(void)
{

    if (itsJsonProtocol)
    {

        QList<AMJsonSignal*> signalsToAppendList;

        foreach (Signal * curSignal, *canSignalsArray)
        {
            //JSON Driven Alerts Triggering:


            QString currSignalStr = curSignal->name;

            //TODO single return point


            QList<AMJsonSignal*> signalsList =  (itsJsonProtocol->getSignalEntries(currSignalStr));

            foreach (AMJsonSignal * jsonsig, signalsList)
            {

                jsonsig->setItsCanDbSignal(curSignal);

                //TODO: for EnumItem table fetch on parsing from the value table
                switch(jsonsig->type)
                {
                case Enabler:

                    canJsonSignalsListInProcessOrder.prepend(jsonsig);

                    break;

                case StringArgument:
                case IntArgument:

                    canJsonSignalsListInProcessOrder.append(jsonsig);

                    break;

                default:

                    signalsToAppendList.append(jsonsig);

                    break;
                }
            }
        }


        canJsonSignalsListInProcessOrder.append(signalsToAppendList);

    }
}

