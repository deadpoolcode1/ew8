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
   explicit AMJsonNumericArgumentAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent = nullptr);

   void process(QObject * sender, QVariant extractedCANsignal);

   bool isItsArgumentsType(qint32 type);

private:
   CanIntArgumentsAccumulator * itsArgumentAccumulator;
};

#endif // AMJSONNUMERICARGUMENTACTION_H
