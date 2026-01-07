
#include "icanrxmsgfactory.h"
#include "defs.h"
#include "canrxmsg.h"

#include "core/serialization.h"
#include "core/file_utils.h"
#include "core/core.h"
#include "core/types.h"
#include <any>
#include <algorithm>

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

// Note: core::DataStream operators for Signal type are defined in candbsignal.cpp

Map<uint32_t, CanRxMsg *> CanRxMsg::CanRxMsgsPool;
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

core::DataStream & operator<< (core::DataStream &out, const CanRxMsg &any)
{
    uint32_t listsize = any.canJsonSignalsPoolIdxInProcessOrder.size();
    out << listsize;
    for(uint32_t i = 0; i < listsize; i++)
    {
        out << (any.canJsonSignalsPoolIdxInProcessOrder.at(i));
    }

    return out;
}

core::DataStream & operator>> (core::DataStream &in, CanRxMsg &any)
{
    uint32_t listsize;


    in >> listsize;
    for(uint32_t i = 0; i < listsize; i++)
    {
        Signal * sig = new Signal();
        in >> *sig;
        any.canJsonSignalsPoolIdxInProcessOrder.push_back(*sig);
    }
    return in;
}


bool CanRxMsg::saveToStorage(void)
{
    bool status = false;

    if(!isAlreadyLoaded)
    {
        core::SaveFile configDump("config.dat");

        if(!configDump.open(core::File::WriteOnly))
        {
            coreDebug() << "Error: Can not write config.dat!";
        }
        else{
            core::DataStream configStream(&configDump);
            configStream.setByteOrder(core::DataStream::BigEndian);


            uint32_t keepAliveOutput = (uint32_t) keepAliveMsgId;
            configStream << keepAliveOutput;
#if 0
            configStream << CanRxMsgsPool.size();
#else
            configStream << (uint32_t)msgsWhiteList.size();
#endif
            Map<CanStdId_t, CanRxMsg *>::iterator i;

            for  (i = CanRxMsgsPool.begin(); i != CanRxMsgsPool.end(); i++)
            {

                CanRxMsg * msg = i->second;
                CanStdId_t id = i->first;
                uint32_t q32Id = static_cast<uint32_t>(id);

                if(std::find(msgsWhiteList.begin(), msgsWhiteList.end(), id) != msgsWhiteList.end())
                {
                    configStream << q32Id;
                    coreDebug() << "saving Msg Number:" << q32Id;
                    configStream << *msg;
                }
            }

        }

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
        core::File configDump("config.dat");

        if(!configDump.open(core::File::ReadOnly))
        {
            coreDebug() << "Error: Can not read config.dat!";
            status = false;
        }
        else{

            std::vector<uint8_t> blob = configDump.readAllBytes();

            core::DataStream configStream(&blob);
            configStream.setByteOrder(core::DataStream::BigEndian);


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
                    msgsWhiteList.push_back(stdId);
                }
                else
                {
                    // Read and discard the signals list
                    uint32_t dummyListSize;
                    configStream >> dummyListSize;
                    for(uint32_t j = 0; j < dummyListSize; j++)
                    {
                        Signal dummySig;
                        configStream >> dummySig;
                    }
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
            CanRxMsgsPool[StdId] = ret;
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

    for (Signal * cansig : *canSignalsArray)
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
        Map<CanStdId_t, CanRxMsg *>::iterator i;

        for  (i = CanRxMsgsPool.begin(); i != CanRxMsgsPool.end(); i++)
        {

            CanRxMsg * msg = i->second;
            CanStdId_t id = i->first;

            if(keepAliveMsgName != "" && msg->itsName == keepAliveMsgName)
            {
               keepAliveMsgId = id;
            }

            if (msg->itsJsonProtocol)
            {
                msg->initCanJsonSignalsListInProcessOrder();

                if(!(msg->canJsonSignalsListInProcessOrder.empty()))
                {
                    msgsWhiteList.push_back(id);
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

    auto it = CanRxMsgsPool.find(StdId);
    ret = (it != CanRxMsgsPool.end()) ? it->second : nullptr;

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


        for (Signal * curSignal : *canSignalsArray)
        {
            //JSON Driven Alerts Triggering:


            String currSignalStr = curSignal->name;

            //TODO single return point


            List<AMJsonSignal*> signalsList =  (itsJsonProtocol->getSignalEntries(currSignalStr));

            for (AMJsonSignal * jsonsig : signalsList)
            {

                jsonsig->setItsCanDbSignal(curSignal);

                String supSignalName = jsonsig->getItsSupName();

                if (!supSignalName.empty())
                {
                    for (Signal * iSignal : *canSignalsArray)
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

                    canJsonSignalsListInProcessOrder.insert(canJsonSignalsListInProcessOrder.begin(), jsonsig);

                    break;

                //TODO verify if arguments are parsed for enabled item only?
                case StringArgument:
                case IntArgument:

                    canJsonSignalsListInProcessOrder.push_back(jsonsig);

                    break;

                default:

                    signalsToAppendList.push_back(jsonsig);

                    break;
                }
            }
        }

        if(requestidcount == 2)
        {
            canJsonSignalsListInProcessOrder.insert(canJsonSignalsListInProcessOrder.begin(), signalsRequestIdArr[1]);
            canJsonSignalsListInProcessOrder.insert(canJsonSignalsListInProcessOrder.begin(), signalsRequestIdArr[0]);
        }

        if(signalValidator != nullptr)
        {
            canJsonSignalsListInProcessOrder.insert(canJsonSignalsListInProcessOrder.begin(), signalValidator);
        }

        canJsonSignalsListInProcessOrder.insert(canJsonSignalsListInProcessOrder.end(), signalsToAppendList.begin(), signalsToAppendList.end());

        List<AMJsonSignal *>::iterator it;

        for (it = canJsonSignalsListInProcessOrder.begin(); it != canJsonSignalsListInProcessOrder.end(); it++)
        {

           AMJsonSignal * jsonsig = *it;

           (jsonsig->getCanDbSignal())->AMJsonSignalIdx = jsonsig->getItsIndex();

           canJsonSignalsPoolIdxInProcessOrder.push_back(*(jsonsig->getCanDbSignal()));

           if(jsonsig->getIsSupplemented())
           {
               (jsonsig->getCanDbSupSignal())->AMJsonSignalIdx = jsonsig->getItsIndex();
               canJsonSignalsPoolIdxInProcessOrder.push_back(*(jsonsig->getCanDbSupSignal()));
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



