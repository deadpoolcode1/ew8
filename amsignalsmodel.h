#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include <QFile>
#include <QJsonDocument>
#include <defs.h>
#include "amjsonprotocol.h"
#include "amjsonsignal.h"
#include "canmanager.h"

#include <QObject>

class AMJsonProtocol;
class AMJsonSignal;
class CanManager;

class AMSignalsModel
{
public:

    explicit AMSignalsModel(CanManager * aManager);

    void jsonInitProtocolsAndSignalsVectors(void);

    AMJsonProtocol * getProtocol(QString aName);

    CanManager * getItsCanManager(void);

private:

    QMap<QString,AMJsonProtocol*> jsonProtocols;

    QList<AMJsonSignal *> jsonEnablerSignals;

    //NOTE: for later one 2 one connecting
    QMap<QString,AMJsonSignal *> jsonGraphicItemSignals;
    QList<AMJsonSignal *> jsonArgumentSignals;
    CanManager * itsCanManager;
};

#endif // AMSIGNALSMODEL_H
