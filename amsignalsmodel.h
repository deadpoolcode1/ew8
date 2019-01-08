#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include <QFile>
#include <QJsonDocument>
#include <defs.h>
#include "amjsonprotocol.h"
#include "amjsonsignal.h"

#include <QObject>

class AMJsonProtocol;
class AMJsonSignal;

class AMSignalsModel
{
public:

    static AMSignalsModel * getInstance(void);

    static QMutex instanceMutex;

    void jsonInitProtocolsAndSignalsVectors(void);

    AMJsonProtocol * getProtocol(QString aName);

private:

    explicit AMSignalsModel();

    static AMSignalsModel * instance;

    QMap<QString,AMJsonProtocol*> jsonProtocols;

    QList<AMJsonSignal *> jsonEnablerSignals;

    //NOTE: for later one 2 one connecting
    QMap<QString,AMJsonSignal *> jsonGraphicItemSignals;
    QList<AMJsonSignal *> jsonArgumentSignals;
};

#endif // AMSIGNALSMODEL_H
