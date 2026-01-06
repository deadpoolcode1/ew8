#ifndef AMJSONNUMERICARGUMENTACTION_H
#define AMJSONNUMERICARGUMENTACTION_H

#include "core/types.h"
#include <QObject>

#include "amjsonargumentaction.h"
#include "canintargumentsaccumulator.h"

class AMJsonArgumentAction;

class AMJsonNumericArgumentAction : public AMJsonArgumentAction
{
    Q_OBJECT

public:
   explicit AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, core::QString action, AMJsonAction * parent = nullptr);

   void process(QObject * sender, core::QVariant extractedCANsignal);

   bool isItsArgumentsType(int32_t type);

private:
   CanIntArgumentsAccumulator * itsArgumentAccumulator;
};

#endif // AMJSONNUMERICARGUMENTACTION_H
