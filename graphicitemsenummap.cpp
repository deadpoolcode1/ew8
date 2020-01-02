#include "graphicitemsenummap.h"

#include "amjsonconfigreader.h"

#include "defs.h"

#include "alerttypes.h"

#include "entitytype.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>

QMutex GraphicItemsEnumMap::instanceMutex;

GraphicItemsEnumMap * GraphicItemsEnumMap::instance;

GraphicItemsEnumMap::GraphicItemsEnumMap()
{
   init();
}

DISPLAY_ITEM_ID GraphicItemsEnumMap::getId(QString name)
{

    GraphicItemsEnumMap * myInstance = getInstance();

    DISPLAY_ITEM_ID ret = myInstance->graphicItemsIDsMap.value(name, (DISPLAY_ITEM_ID)AlertTypes::ALERT_NONE);

    return ret;
}

QString GraphicItemsEnumMap::getName(DISPLAY_ITEM_ID id)
{
    GraphicItemsEnumMap * myInstance = getInstance();

    QString ret = myInstance->graphicItemsNamesMap.value(id,"");

    return ret;
}

void GraphicItemsEnumMap::init(void)
{
    QJsonObject jsonObject = AMJsonConfigReader::getInstance()->object();

    QJsonArray jsonArray = jsonObject["GraphicItem"].toArray();


    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject obj = value.toObject();

        QString name = obj["enum"].toString();

        DISPLAY_ITEM_ID id = obj["value"].toInt();

        qDebug("JSON: %s",  qPrintable(name));
        qDebug("JSON: %d",  id);

        graphicItemsIDsMap.insert(name,id);
        graphicItemsNamesMap.insert(id, name);


        //TODO verify that those values are presented also in JSON signals
        //TODO remove hardcoded ALERTS
        EntityType::generateSingleType(id);

    }

}

GraphicItemsEnumMap * GraphicItemsEnumMap::getInstance(void)
{
    if(nullptr == instance)
    {
        instanceMutex.lock();
        if(nullptr == instance)
        {
            instance = new GraphicItemsEnumMap();
        }
        instanceMutex.unlock();
    }

    return instance;
}
