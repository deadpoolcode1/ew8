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
    DISPLAY_ITEM_ID ret = (DISPLAY_ITEM_ID)AlertTypes::ALERT_NONE;

    GraphicItemsEnumMap * myInstance = getInstance();

    QHash<QString, DISPLAY_ITEM_ID>::iterator it = myInstance->graphicItemsIDsMap.find(name);

    if(it != myInstance->graphicItemsIDsMap.end())
    {
        ret = it.value();
    }

    return ret;
}

QString GraphicItemsEnumMap::getName(DISPLAY_ITEM_ID id)
{
    QString ret = "";

     GraphicItemsEnumMap * myInstance = getInstance();

    QHash<DISPLAY_ITEM_ID, QString>::iterator it = myInstance->graphicItemsNamesMap.find(id);

    if(it != myInstance->graphicItemsNamesMap.end())
    {
        ret = it.value();
    }
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
