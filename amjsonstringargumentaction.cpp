#include "amjsonstringargumentaction.h"
#include "canstringargumentsaccumulator.h"
#include "amjsonsignal.h"

#include "candbsignal.h"

class AMJsonProtocol;


AMJsonStringArgumentAction::AMJsonStringArgumentAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonArgumentAction(aJsonProtocol, StringArgument, action, parent)
{
    itsArgumentAccumulator = CanStringArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonStringArgumentAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,extractedCANsignal.toChar().toLatin1());
}


bool AMJsonStringArgumentAction::isItsArgumentsType(qint32 type)
{
    return (type == StringArgument);
}
