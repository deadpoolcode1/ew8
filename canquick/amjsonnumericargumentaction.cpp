#include "amjsonnumericargumentaction.h"

#include "canintargumentsaccumulator.h"

#include "amjsonsignal.h"

class AMJsonProtocol;

class CanIntArgumentsAccumulator;

AMJsonNumericArgumentAction::AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonArgumentAction(aJsonProtocol, IntArgument, action, parent)
{
    itsArgumentAccumulator = CanIntArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonNumericArgumentAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,extractedCANsignal.toInt());
}

bool AMJsonNumericArgumentAction::isItsArgumentsType(qint32 type)
{
    return (type == (qint32)IntArgument);
}
