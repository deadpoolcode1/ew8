#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include "core/file_utils.h"
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

    AMJsonProtocol * getProtocol(const String& aName);

    CanManager * getItsCanManager(void);

    void storeCollectedAction(AMJsonAction * anAction);

    IAMJsonActionFactory * getItsAMJsonActionFactory(){return itsAMJsonActionFactory;}

private:

    void jsonInitProtocolsAndSignalsVectors(void);

    Map<String,AMJsonProtocol*> jsonProtocols;

    List<AMJsonEnablerAction *> jsonEnablerActions;

    //NOTE: for later one 2 one connecting
    Map<String,AMJsonGraphicItemAction *> jsonGraphicItemActions;
    List<AMJsonArgumentAction *> jsonArgumentActions;

    CanManager * itsCanManager;
    IAMJsonActionFactory * itsAMJsonActionFactory;
};

#endif // AMSIGNALSMODEL_H
