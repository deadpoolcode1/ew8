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
    explicit AMJsonStringArgumentAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent = nullptr);

    void process(QObject * sender, QVariant extractedCANsignal);

    bool isItsArgumentsType(int32_t type);

private:
    CanStringArgumentsAccumulator * itsArgumentAccumulator;

};

#endif // AMJSONSTRINGARGUMENTACTION_H
