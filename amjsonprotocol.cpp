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
