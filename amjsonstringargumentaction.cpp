#include "amjsonstringargumentaction.h"
#include "canstringargumentsaccumulator.h"
#include "amjsonsignal.h"

#include "candbsignal.h"

class AMJsonProtocol;


AMJsonStringArgumentAction::AMJsonStringArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action): AMJsonArgumentAction(aJsonProtocol, StringArgument, action)
{
    itsArgumentAccumulator = CanStringArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonStringArgumentAction::process(void * /*sender*/, Variant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,(char)variantToInt(extractedCANsignal));
}


bool AMJsonStringArgumentAction::isItsArgumentsType(int32_t type)
{
    return (type == StringArgument);
}
