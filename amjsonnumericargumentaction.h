#ifndef AMJSONNUMERICARGUMENTACTION_H
#define AMJSONNUMERICARGUMENTACTION_H

#include <QObject>

#include "amjsonargumentaction.h"
#include "canintargumentsaccumulator.h"
#include "core/types.h"

class AMJsonArgumentAction;

class AMJsonNumericArgumentAction : public AMJsonArgumentAction
{
    Q_OBJECT

public:
   explicit AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, const String& action, AMJsonAction * parent = nullptr);

   void process(QObject * sender, QVariant extractedCANsignal);

   bool isItsArgumentsType(int32_t type);

private:
   CanIntArgumentsAccumulator * itsArgumentAccumulator;
};

#endif // AMJSONNUMERICARGUMENTACTION_H
