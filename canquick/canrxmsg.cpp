
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

#include <QDataStream>
#include <QSaveFile>
#include "core/core.h"
#include "core/types.h"
#include <any>

// Helper function to convert std::any to QVariant
static QVariant anyToVariant(const std::any& val)
{
    if (!val.has_value()) {
        return QVariant();
    }
    if (val.type() == typeid(bool)) {
        return QVariant(std::any_cast<bool>(val));
    }
    if (val.type() == typeid(int32_t)) {
        return QVariant(std::any_cast<int32_t>(val));
    }
    if (val.type() == typeid(double)) {
        return QVariant(std::any_cast<double>(val));
    }
    if (val.type() == typeid(float)) {
        return QVariant(static_cast<double>(std::any_cast<float>(val)));
    }
    return QVariant();
}

// QDataStream operators for Signal type
QDataStream & operator<< (QDataStream &out, const Signal &sig)
{
    SerializedSignal_t sesig;
    sesig.startByte = sig.startByte;
    sesig.startBit = sig.startBit;
    sesig.numOfBits = sig.numOfBits;
    sesig.sign = static_cast<uint8_t>(sig.sign);
    sesig.factor = sig.factor;
    sesig.offset = sig.offset;
    sesig.min = sig.min;
    sesig.max = sig.max;
    sesig.enumValueType = static_cast<int8_t>(sig.valueType);
    sesig.AMJsonSignalIdx = sig.AMJsonSignalIdx;
    out.writeRawData((const char*)(&sesig), sizeof(SerializedSignal_t));
    return out;
}

QDataStream & operator>> (QDataStream &in, Signal &sig)
{
    SerializedSignal_t sesig;
    in.readRawData((char*)&sesig, sizeof(SerializedSignal_t));
    sig.startByte = sesig.startByte;
    sig.startBit = sesig.startBit;
    sig.numOfBits = sesig.numOfBits;
    sig.sign = sesig.sign ? true : false;
    sig.factor = sesig.factor;
    sig.offset = sesig.offset;
    sig.min = sesig.min;
    sig.max = sesig.max;
    sig.valueType = static_cast<SignalValueType>(sesig.enumValueType);
    sig.AMJsonSignalIdx = sesig.AMJsonSignalIdx;
    return in;
}

QMap <uint32_t, CanRxMsg *> CanRxMsg::CanRxMsgsPool;
ICanRxMsgFactory * CanRxMsg::iCanRxMsgFactory = nullptr;
AMSignalsModel * CanRxMsg::itsAMSignalsModel = nullptr;
MeDisconnectionReport * CanRxMsg::itsDisconnectionReport = nullptr;
List<CanStdId_t> CanRxMsg::msgsWhiteList;
bool CanRxMsg::isAlreadyLoaded = false;
bool CanRxMsg::isDBCParsingForced = false;

bool CanRxMsg::isRequestSent = false;
bool CanRxMsg::isRequestIdLSBByteReceived = false;
uint16_t CanRxMsg::requestId = 0x0;
String CanRxMsg::keepAliveMsgName;
CanStdId_t CanRxMsg::keepAliveMsgId = 0x0;
int32_t CanRxMsg::keepAliveTimeout;


void CanRxMsg::setKeepAliveMsg(const String& aKeepAliveMsgName, int32_t aKeepAliveTimeout)
{
  if(keepAliveMsgName.empty())
  {
    keepAliveMsgName = aKeepAliveMsgName;
    keepAliveTimeout = aKeepAliveTimeout;
  }
  else
  {
    coreDebug() << "Abmiguous keep alive message definition. Must  be only one";
  }
}

QDataStream & operator<< (QDataStream &out, const CanRxMsg &any)
{
    uint32_t listsize = any.canJsonSignalsPoolIdxInProcessOrder.size();
    out << listsize;
    for(uint32_t i = 0; i < listsize; i++)
    {
        out << (any.canJsonSignalsPoolIdxInProcessOrder.at(i));
    }

    return out;
}

QDataStream & operator>> (QDataStream &in, CanRxMsg &any)
{
    uint32_t listsize;


    in >> listsize;
    for(uint32_t i = 0; i < listsize; i++)
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
            coreDebug() << "Error: Can not write config.dat!";
        }
        else{
            QDataStream configStream( & configDump);
            configStream.setByteOrder(QDataStream::BigEndian);
            configStream.setVersion(QDataStream::Qt_5_9);
            configStream.setFloatingPointPrecision(QDataStream:: SinglePrecision);


            uint32_t keepAliveOutput = (uint32_t) keepAliveMsgId;
            configStream << keepAliveOutput;
#if 0
            configStream << CanRxMsgsPool.size();
#else
            configStream << (uint32_t)msgsWhiteList.size();
#endif
            QMap<CanStdId_t, CanRxMsg *>::iterator i;

            for  (i = CanRxMsgsPool.begin(); i != CanRxMsgsPool.end(); i++)
            {

                CanRxMsg * msg = i.value();
                CanStdId_t id = i.key();
                uint32_t q32Id = static_cast<uint32_t>(id);

                if(msgsWhiteList.contains(id))
                {
                    configStream << q32Id;
                    coreDebug() << "saving Msg Number:" << q32Id;
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


void CanRxMsg::setItsDisconnectionReport(MeDisconnectionReport *aDisconnectionReport)
{
    itsDisconnectionReport = aDisconnectionReport;
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

        if(!configDump.open(QFile::ReadOnly))
        {
            coreDebug() << "Error: Can not read config.dat!";
            status = false;
        }
        else{

            auto blob = configDump.readAll();

            QDataStream configStream(blob);
            configStream.setByteOrder(QDataStream::BigEndian);
            configStream.setVersion(QDataStream::Qt_5_9);
            configStream.setFloatingPointPrecision(QDataStream:: SinglePrecision);


            uint32_t keepAliveInput;
            configStream >> keepAliveInput;

            keepAliveMsgId = (CanStdId_t)keepAliveInput;


            uint32_t msgNum;

            configStream >> msgNum;

            coreDebug() << "Size of loaded CanRxMsgs Pool is" << msgNum;

            uint32_t stdId;

            CanRxMsg dummybuff;

            for  (size_t i=0; i < msgNum; i++)
            {


                configStream >> stdId;

                CanRxMsg * rxmsg = CanRxMsg::createInstance(stdId, "");

                coreDebug() << "StdId:" << (int32_t)stdId;

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

void CanRxMsg::expectRequestId(uint16_t aRequestId)
{
    requestId = aRequestId;
    isRequestSent = true;
    isRequestIdLSBByteReceived = false;
    itsDisconnectionReport->startRequestTimeoutTimer();
}

void CanRxMsg::receiveRequestIdByteLSB(uint8_t aByte)
{
    isRequestIdLSBByteReceived = isRequestSent &&
            ((uint16_t)aByte == (requestId & (uint16_t)0xff));
}

void CanRxMsg::receiveRequestIdByteMSB(uint8_t aByte)
{
    if(isRequestIdLSBByteReceived && ((uint16_t)aByte == ((requestId >> 010) & (uint16_t)0xff)))
    {
        isRequestSent = false;
        itsDisconnectionReport->stopRequestTimeoutTimer();
    }

}

void CanRxMsg::discardRequestId(void)
{
    isRequestIdLSBByteReceived = false;
    isRequestSent = false;
}





CanRxMsg * CanRxMsg::createInstance(uint32_t StdId, const String& aName)
{
    CanRxMsg * ret = getMsgByCanId(StdId);
    //TODO review the check location
    if(nullptr == ret) //create new unstance
    {
      //TODO use factory and init with id
        ret = iCanRxMsgFactory->createCanRxMsgInstance(StdId);
        if(nullptr != ret)
        {
            ret->itsName = aName;
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

Signal * CanRxMsg::getCANSignalByName(const String& name)
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
    coreDebug() << "CanRxMsgsPool is ready for usage";
}

const List<CanStdId_t> & CanRxMsg::getMsgsWhiteList(void)
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

            if(keepAliveMsgName != "" && msg->itsName == keepAliveMsgName)
            {
               keepAliveMsgId = id;
            }

            if (msg->itsJsonProtocol)
            {
                msg->initCanJsonSignalsListInProcessOrder();

                if(!(msg->canJsonSignalsListInProcessOrder.isEmpty()))
                {
                    msgsWhiteList.append(id);
                }
            }
        }
    }
}

CanRxMsg::CanRxMsg()
{
    itsJsonProtocol = nullptr;
}

void CanRxMsg::applyCanDBSignalsArray(List<Signal *> * signalsList)
{
    //canSignalsArray =  new List<Signal *>();

    canSignalsArray = signalsList;

    coreDebug() << "Added signal list to the message";
}

CanRxMsg * CanRxMsg::getMsgByCanId(uint32_t StdId)
{
    CanRxMsg * ret = nullptr;

    ret = CanRxMsgsPool.value(StdId, nullptr);

    return ret;
}

void CanRxMsg::initCanJsonSignalsListInProcessOrder(void)
{




    if (itsJsonProtocol)
    {

        AMJsonSignal* signalValidator = nullptr;
        AMJsonSignal* signalsRequestIdArr[2];
        uint8_t requestidcount = 0;
        List<AMJsonSignal*> signalsToAppendList;


        foreach (Signal * curSignal, *canSignalsArray)
        {
            //JSON Driven Alerts Triggering:


            String currSignalStr = curSignal->name;

            //TODO single return point


            List<AMJsonSignal*> signalsList =  (itsJsonProtocol->getSignalEntries(currSignalStr));

            foreach (AMJsonSignal * jsonsig, signalsList)
            {

                jsonsig->setItsCanDbSignal(curSignal);

                String supSignalName = jsonsig->getItsSupName();

                if (!supSignalName.empty())
                {
                    foreach (Signal * iSignal, *canSignalsArray)
                    {
                        if(iSignal->name == supSignalName)
                        {
                            jsonsig->setItsCanSecDbSignal(iSignal);
                        }
                    }
                }

                //TODO: for EnumItem table fetch on parsing from the value table
                switch(jsonsig->type)
                {
                case Validator:
                    signalValidator = jsonsig;
                    break;

                case RequestId:
                    if(jsonsig->index == 0)
                    {
                        signalsRequestIdArr[0] = jsonsig;
                        requestidcount++;
                    }

                    if(jsonsig->index == 1)
                    {
                        signalsRequestIdArr[1] = jsonsig;
                        requestidcount++;
                    }

                    break;

                case Enabler:

                    canJsonSignalsListInProcessOrder.prepend(jsonsig);

                    break;

                //TODO verify if arguments are parsed for enabled item only?
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

        if(requestidcount == 2)
        {
            canJsonSignalsListInProcessOrder.prepend(signalsRequestIdArr[1]);
            canJsonSignalsListInProcessOrder.prepend(signalsRequestIdArr[0]);
        }

        if(signalValidator != nullptr)
        {
            canJsonSignalsListInProcessOrder.prepend(signalValidator);
        }

        canJsonSignalsListInProcessOrder.append(signalsToAppendList);

        List<AMJsonSignal *>::iterator it;

        for (it = canJsonSignalsListInProcessOrder.begin(); it != canJsonSignalsListInProcessOrder.end(); it++)
        {

           AMJsonSignal * jsonsig = *it;

           (jsonsig->getCanDbSignal())->AMJsonSignalIdx = jsonsig->getItsIndex();

           canJsonSignalsPoolIdxInProcessOrder.append(*(jsonsig->getCanDbSignal()));

           if(jsonsig->getIsSupplemented())
           {
               (jsonsig->getCanDbSupSignal())->AMJsonSignalIdx = jsonsig->getItsIndex();
               canJsonSignalsPoolIdxInProcessOrder.append(*(jsonsig->getCanDbSupSignal()));
           }

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
    List<Signal>::iterator it;
    bool discardMsgOnRequestIdFail = false;
    bool discardMsg = false;

    //WARNING: Did not use foreach to show, the sequence is important
    for (it = canJsonSignalsPoolIdxInProcessOrder.begin(); (!discardMsg && it != canJsonSignalsPoolIdxInProcessOrder.end()); it++)
    {


        AMJsonSignal * jsonsig = AMJsonSignal::getByIndex(it->AMJsonSignalIdx);

        QVariant arg = 0;
        QVariant supArg = 0;

        if(!jsonsig)
        {
            coreDebug() << "Unknown signal id:";
        }
        else
        {
            Signal tmp = *it;

            arg = anyToVariant(extractSignal(&tmp, frame));

            if(jsonsig->type == Validator)
            {
                bool isValidData;
                if(jsonsig->extractSetUnsetAction(arg,&isValidData))
                {discardMsg = !isValidData;}
                else
                {discardMsg = true;}

            }
            else
            {


                //WARNING: unusual process
                if(jsonsig->type == RequestId)
                {
                    discardMsgOnRequestIdFail = true;
                }
                else if(discardMsgOnRequestIdFail)
                {
                    //Check the requestId
                    if(isRequestIdLSBByteReceived && !isRequestSent)
                    {
                        discardMsgOnRequestIdFail = false;
                    }
                    else
                    {
                        isRequestIdLSBByteReceived = false;
                        discardMsg = true;
                    }
                }

                if(!discardMsg&&!(arg.isNull()))
                {


                    if (! jsonsig->getIsSupplemented())
                    {
                        jsonsig->process(arg);
                    }
                    else
                    {
                        Signal supSig =  * (++it);
                        supArg =  anyToVariant(extractSignal(&supSig, frame));
                        jsonsig->process(arg, supArg);

                    }
                }
            }
        }
    }

}



