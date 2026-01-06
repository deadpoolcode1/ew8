#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include <QFile>
#include "core/json.h"
#include <defs.h>
#include "amjsonprotocol.h"
#include "amjsonsignal.h"
#include "amjsonaction.h"
#include "amjsongraphicitemaction.h"
#include "amjsonargumentaction.h"
#include "amjsonenableraction.h"
#include "canmanager.h"

#include "iamjsonactionfactory.h"

#include <QObject>

class IAMJsonActionFactory;

class AMJsonAction;
class AMJsonEnablerAction;
class AMJsonArgumentAction;
class AMJsonGraphicItemAction;

class AMJsonProtocol;
class AMJsonSignal;
class CanManager;

class AMSignalsModel
{
public:

    explicit AMSignalsModel(CanManager * aManager);

    AMJsonProtocol * getProtocol(core::QString aName);

    CanManager * getItsCanManager(void);

    void storeCollectedAction(AMJsonAction * anAction);

    IAMJsonActionFactory * getItsAMJsonActionFactory(){return itsAMJsonActionFactory;}

private:

    void jsonInitProtocolsAndSignalsVectors(void);

    core::QMap<core::QString,AMJsonProtocol*> jsonProtocols;

    core::QList<AMJsonEnablerAction *> jsonEnablerActions;

    //NOTE: for later one 2 one connecting
    core::QMap<core::QString,AMJsonGraphicItemAction *> jsonGraphicItemActions;
    core::QList<AMJsonArgumentAction *> jsonArgumentActions;

    CanManager * itsCanManager;
    IAMJsonActionFactory * itsAMJsonActionFactory;
};

#endif // AMSIGNALSMODEL_H
