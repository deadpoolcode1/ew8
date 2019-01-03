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

    qint32 jsonGetGraphicItemEnum(QString jsonEnumItem);
    void jsonInitProtocolsAndSignalsVectors(void);

    AMJsonProtocol * getProtocol(QString aName);

private:

    explicit AMSignalsModel();

    static AMSignalsModel * instance;

    json_enum_t graphicItemsEnumMap;

    QMap<QString,AMJsonProtocol*> jsonProtocols;

    void jsonInitGraphicItemEnumMap(void);

    QList<AMJsonSignal *> jsonEnablerSignals;

    QJsonDocument jsonDocument;
};

#endif // AMSIGNALSMODEL_H
