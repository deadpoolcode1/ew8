#ifndef AMJSONSTRINGARGUMENTACTION_H
#define AMJSONSTRINGARGUMENTACTION_H

#include "amjsonargumentaction.h"
#include "canstringargumentsaccumulator.h"
#include "core/types.h"

class AMJsonArgumentAction;
class CanStringArgumentsAccumulator;

class AMJsonStringArgumentAction : public AMJsonArgumentAction
{
public:
    explicit AMJsonStringArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action);

    void process(void * sender, Variant extractedCANsignal);

    bool isItsArgumentsType(int32_t type);

private:
    CanStringArgumentsAccumulator * itsArgumentAccumulator;

};

#endif // AMJSONSTRINGARGUMENTACTION_H
