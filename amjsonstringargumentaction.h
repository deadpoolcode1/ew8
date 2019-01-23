#ifndef AMJSONSTRINGARGUMENTACTION_H
#define AMJSONSTRINGARGUMENTACTION_H

#include "amjsonargumentaction.h"
#include "canstringargumentsaccumulator.h"

class AMJsonArgumentAction;
class CanStringArgumentsAccumulator;

class AMJsonStringArgumentAction : public AMJsonArgumentAction
{
    Q_OBJECT

public:
    explicit AMJsonStringArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent = nullptr);

    void process(QVariant extractedCANsignal);

private:
    CanStringArgumentsAccumulator * itsArgumentAccumulator;

};

#endif // AMJSONSTRINGARGUMENTACTION_H
