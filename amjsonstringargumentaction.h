#ifndef AMJSONSTRINGARGUMENTACTION_H
#define AMJSONSTRINGARGUMENTACTION_H

#include "amjsonargumentaction.h"
#include "canstringargumentsaccumulator.h"
#include "core/types.h"

class AMJsonArgumentAction;
class CanStringArgumentsAccumulator;

class AMJsonStringArgumentAction : public AMJsonArgumentAction
{
    Q_OBJECT

public:
    explicit AMJsonStringArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action, AMJsonAction * parent = nullptr);

    void process(QObject * sender, Variant extractedCANsignal);

    bool isItsArgumentsType(int32_t type);

private:
    CanStringArgumentsAccumulator * itsArgumentAccumulator;

};

#endif // AMJSONSTRINGARGUMENTACTION_H
