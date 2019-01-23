#include "amjsonnumericargumentaction.h"

#include "canintargumentsaccumulator.h"

class CanIntArgumentsAccumulator;

AMJsonNumericArgumentAction::AMJsonNumericArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent): AMJsonArgumentAction(aJsonSignal, action, parent)
{
    itsArgumentAccumulator = CanIntArgumentsAccumulator::getInstance(itsGraphicItemID);
}

void AMJsonNumericArgumentAction::process(QVariant extractedCANsignal)
{
    itsArgumentAccumulator->insertValueFromSignal(itsIndex,extractedCANsignal.toInt());
}
