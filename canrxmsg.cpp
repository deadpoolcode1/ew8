
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

#include <QDataStream>
#include <QSaveFile>
#include <QDebug>

QMap <quint32, CanRxMsg *> CanRxMsg::CanRxMsgsPool;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;
AMSignalsModel * CanRxMsg::itsAMSignalsModel = nullptr;
QList<CanStdId_t> CanRxMsg::msgsWhiteList;
bool CanRxMsg::isAlreadyLoaded = false;
bool CanRxMsg::isDBCParsingForced = false;

QDataStream & operator<< (QDataStream &out, const CanRxMsg &any)
{
    quint32 listsize = any.canJsonSignalsPoolIdxInProcessOrder.size();
    out << listsize;
    for(quint32 i = 0; i < listsize; i++)
    {
        out << (any.canJsonSignalsPoolIdxInProcessOrder.at(i));
    }

    return out;
}

QDataStream & operator>> (QDataStream &in, CanRxMsg &any)
{
    quint32 listsize;
    in >> listsize;
    for(quint32 i = 0; i < listsize; i++)
    {
        Signal * sig = new Signal();
        in >> *sig;
        any.canJsonSignalsPoolIdxInProcessOrder.append(*sig);
    }
    return in;
}


bool CanRxMsg::saveToStorage(void)
{
    bool status = false;

    if(!isAlreadyLoaded)
    {
        QSaveFile configDump("config.dat");

        if(!configDump.open(QFile::WriteOnly))
        {
            qDebug("Error: Can not write config.dat!");
        }
        else{
            QDataStream configStream( & configDump);
            configStream.setByteOrder(QDataStream::BigEndian);
            configStream.setVersion(QDataStream::Qt_5_9);
            configStream.setFloatingPointPrecision(QDataStream:: SinglePrecision);

#if 0
            configStream << CanRxMsgsPool.size();
#else
            configStream << (quint32)msgsWhiteList.size();
#endif
            QMap<CanStdId_t, CanRxMsg *>::iterator i;

            for  (i = CanRxMsgsPool.begin(); i != CanRxMsgsPool.end(); i++)
            {

                CanRxMsg * msg = i.value();
                CanStdId_t id = i.key();
                quint32 q32Id = static_cast<quint32>(id);

                if(msgsWhiteList.contains(id))
                {
                    configStream << q32Id;
                    qDebug() << "saving Msg Number:" << q32Id;
                    configStream << *msg;
                    configStream.commitTransaction();
                    configDump.flush();
                }
            }

        }

        configDump.flush();
        configDump.commit();
    }
    return status;
}

void CanRxMsg::forceDBCParsing(void)
{
    isDBCParsingForced = true;
}


bool CanRxMsg::loadFromStorage(void)
{
    bool status = true;

    if(!isDBCParsingForced)
    {
        QFile configDump("config.dat");

        QByteArray blob;

        if(!configDump.open(QFile::ReadOnly))
        {
            qDebug("Error: Can not read config.dat!");
            status = false;
        }
        else{

            blob = configDump.readAll();

            QDataStream configStream(blob);
            configStream.setByteOrder(QDataStream::BigEndian);
            configStream.setVersion(QDataStream::Qt_5_9);
            configStream.setFloatingPointPrecision(QDataStream:: SinglePrecision);


            quint32 msgNum;

            configStream >> msgNum;

            qDebug() << "Size of loaded CanRxMsgs Pool is" << msgNum;

            quint32 stdId;

            CanRxMsg dummybuff;

            for  (size_t i=0; i < msgNum; i++)
            {


                configStream >> stdId;

                CanRxMsg * rxmsg = CanRxMsg::createInstance(stdId);

                qDebug() << "StdId:" << (qint32)stdId;

                if(rxmsg)
                {
                    configStream >> *rxmsg;
                    msgsWhiteList.append(stdId);
                }
                else
                {
                    configStream >> dummybuff.canJsonSignalsPoolIdxInProcessOrder;
                }



            }

            isAlreadyLoaded = true;

        }

        configDump.close();
    }
    return status;
}


CanRxMsg * CanRxMsg::createInstance(quint32 StdId)
{
    CanRxMsg * ret = getMsgByCanId(StdId);
    //TODO review the check location
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id
        ret = iCanRxMsgFactory->createCanRxMsgInstance(StdId);
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
    itsJsonProtocolName =  itsJsonProtocol->getName();
    if(!isAlreadyLoaded)
    {
        initCanJsonSignalsListInProcessOrder();
    }
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
    CanRxMsg::loadFromStorage();
    qDebug("CanRxMsgsPool is ready for usage");
}

const QList<CanStdId_t> & CanRxMsg::getMsgsWhiteList(void)
{
    return msgsWhiteList;
}

void CanRxMsg::completeInitCanRxMsgsPool()
{
    if(!isAlreadyLoaded)
    {
        QMap<CanStdId_t, CanRxMsg *>::iterator i;

        for  (i = CanRxMsgsPool.begin(); i != CanRxMsgsPool.end(); i++)
        {

            CanRxMsg * msg = i.value();
            CanStdId_t id = i.key();

#if 1
            if (msg->itsJsonProtocol)
            {
                msg->initCanJsonSignalsListInProcessOrder();
#endif

                if(!(msg->canJsonSignalsListInProcessOrder.isEmpty()))
                {
                    msgsWhiteList.append(id);
                }
#if 1
            }
#endif
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

        QList<AMJsonSignal *>::iterator it;

        for (it = canJsonSignalsListInProcessOrder.begin(); it != canJsonSignalsListInProcessOrder.end(); it++)
        {

           AMJsonSignal * jsonsig = *it;

           (jsonsig->getCanDbSignal())->AMJsonSignalIdx = jsonsig->getItsIndex();

           canJsonSignalsPoolIdxInProcessOrder.append(*(jsonsig->getCanDbSignal()));

        }

    }
}


void CanRxMsg::process(struct can_frame * frame)
{
       canRxJsonSignalsParseAndProcess(frame);
}


void CanRxMsg::ack(CanManager *)
{
    /*skip*/
}

void CanRxMsg::canRxJsonSignalsParseAndProcess(struct can_frame * frame)
{
    QList<Signal>::iterator it;

    //WARNING: Did not use foreach to show, the sequence is important
    for (it = canJsonSignalsPoolIdxInProcessOrder.begin(); it != canJsonSignalsPoolIdxInProcessOrder.end(); it++)
    {


        AMJsonSignal * jsonsig = AMJsonSignal::getByIndex(it->AMJsonSignalIdx);

        QVariant arg = 0;

        if(!jsonsig)
        {
            qDebug() << "Unknown signal id:";
        }
        else
        {
            Signal tmp = *it;

            sg_var_t sgvar = extractSignal(&tmp, frame);

            //TODO: convert to QVariant(?)
            switch(sgvar.sg_type)
            {
            case EXT_SG_VAL_TYPE_INTEGER:
                arg = QVariant(sgvar.sg_val._int);
                break;
            case EXT_SG_VAL_TYPE_BOOL:
                arg = QVariant(sgvar.sg_val._bool);
                break;

            case EXT_SG_VAL_TYPE_DOUBLE:
                arg = QVariant(sgvar.sg_val._double);
                break;

            default:

                qDebug ("Extracted signal type broken");

            }

            jsonsig->process(arg);

        }


    }

}



