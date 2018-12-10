#ifndef AMSIGNALSMODEL_H
#define AMSIGNALSMODEL_H

#include <QFile>
#include <QJsonDocument>
#include <defs.h>
#include "amjsonprotocol.h"
#include "amjsonsignal.h"

#include <QObject>

class AMJsonProtocol;

class AMSignalsModel
{
public:

    AMSignalsModel();

    qint32 jsonGetGraphicItemEnum(QString jsonEnumItem);
    void jsonInitProtocolsAndSignalsVectors(void);

private:

    json_enum_t graphicItemsEnumMap;

    std::vector<AMJsonProtocol> jsonProtocols;

    void jsonInitGraphicItemEnumMap(void);

    QJsonDocument jsonDocument;
};

#endif // AMSIGNALSMODEL_H
