#include "amjsonstringargumentaction.h"
#include "canstringargumentsaccumulator.h"

#include "candbsignal.h"



AMJsonStringArgumentAction::AMJsonStringArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent): AMJsonArgumentAction(aJsonSignal, action, parent)
{
    itsArgumentAccumulator = CanStringArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonStringArgumentAction::process(QVariant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,extractedCANsignal.toChar().toLatin1());
}
