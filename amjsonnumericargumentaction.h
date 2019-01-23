#ifndef AMJSONNUMERICARGUMENTACTION_H
#define AMJSONNUMERICARGUMENTACTION_H

#include <QObject>

#include "amjsonargumentaction.h"
#include "canintargumentsaccumulator.h"

class AMJsonArgumentAction;

class AMJsonNumericArgumentAction : public AMJsonArgumentAction
{
    Q_OBJECT

public:
   explicit AMJsonNumericArgumentAction(AMJsonSignal * aJsonSignal, QString action, AMJsonAction * parent = nullptr);

   void process(QVariant extractedCANsignal);

private:
   CanIntArgumentsAccumulator * itsArgumentAccumulator;
};

#endif // AMJSONNUMERICARGUMENTACTION_H
