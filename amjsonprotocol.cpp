#include "amjsonprotocol.h"

#include "amjsonsignal.h"

AMJsonProtocol::AMJsonProtocol(QString aName)
{
    qDebug("JSON: new protocol extracted: %s",qPrintable(aName));
    name = aName;
}

void AMJsonProtocol::append(AMJsonSignal *signal)
{

    jsonSignals.push_back(*signal);

}

AMJsonSignal * AMJsonProtocol::getSignal(QString aName)
{
    AMJsonSignal * ret = nullptr;

   for(std::vector<AMJsonSignal>::iterator iter = jsonSignals.begin();iter != jsonSignals.end();++iter)
    {
        if(iter->getName() ==  aName)
        {
            ret =  &*iter;
        }
    }
    return ret;
}


QString AMJsonProtocol::getName(void)
{
    return name;
}
