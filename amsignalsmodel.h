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

    static AMSignalsModel * getInstance(void);

    qint32 jsonGetGraphicItemEnum(QString jsonEnumItem);
    void jsonInitProtocolsAndSignalsVectors(void);

    AMJsonProtocol * getProtocol(QString aName);

private:

    AMSignalsModel();

    static AMSignalsModel * instance;

    json_enum_t graphicItemsEnumMap;

    std::vector<AMJsonProtocol> jsonProtocols;

    void jsonInitGraphicItemEnumMap(void);



    QJsonDocument jsonDocument;
};

#endif // AMSIGNALSMODEL_H
