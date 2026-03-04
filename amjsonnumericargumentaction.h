#ifndef AMJSONNUMERICARGUMENTACTION_H
#define AMJSONNUMERICARGUMENTACTION_H

#include "amjsonargumentaction.h"
#include "canintargumentsaccumulator.h"
#include "core/types.h"

class AMJsonArgumentAction;

class AMJsonNumericArgumentAction : public AMJsonArgumentAction
{
public:
   explicit AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action);

   void process(void * sender, Variant extractedCANsignal);

   bool isItsArgumentsType(int32_t type);

private:
   CanIntArgumentsAccumulator * itsArgumentAccumulator;
};

#endif // AMJSONNUMERICARGUMENTACTION_H
