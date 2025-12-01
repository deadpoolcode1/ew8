#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include <QFile>
#include <QJsonDocument>
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

    AMJsonProtocol * getProtocol(QString aName);

    CanManager * getItsCanManager(void);

    void storeCollectedAction(AMJsonAction * anAction);

    IAMJsonActionFactory * getItsAMJsonActionFactory(){return itsAMJsonActionFactory;}

private:

    void jsonInitProtocolsAndSignalsVectors(void);

    QMap<QString,AMJsonProtocol*> jsonProtocols;

    QList<AMJsonEnablerAction *> jsonEnablerActions;

    //NOTE: for later one 2 one connecting
    QMap<QString,AMJsonGraphicItemAction *> jsonGraphicItemActions;
    QList<AMJsonArgumentAction *> jsonArgumentActions;

    CanManager * itsCanManager;
    IAMJsonActionFactory * itsAMJsonActionFactory;
};

#endif // AMSIGNALSMODEL_H
