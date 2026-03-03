#include "amjsonnumericargumentaction.h"

#include "canintargumentsaccumulator.h"

#include "amjsonsignal.h"

class AMJsonProtocol;

class CanIntArgumentsAccumulator;

AMJsonNumericArgumentAction::AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action, AMJsonAction * parent): AMJsonArgumentAction(aJsonProtocol, IntArgument, action, parent)
{
    itsArgumentAccumulator = CanIntArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonNumericArgumentAction::process(QObject * /*sender*/, Variant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,variantToInt(extractedCANsignal));
}

bool AMJsonNumericArgumentAction::isItsArgumentsType(int32_t type)
{
    return (type == (int32_t)IntArgument);
}
