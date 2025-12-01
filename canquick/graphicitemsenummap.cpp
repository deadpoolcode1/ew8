#include "graphicitemsenummap.h"

#include "amjsonconfigreader.h"

#include "defs.h"

#include "alerttypes.h"

#include "entitytype.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QDebug>

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
     QJsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("GraphicItems").toArray();

    DISPLAY_ITEM_ID id;

#ifdef DYNAMIC_DISPLAY_ITEM_ID
    id =  ((DISPLAY_ITEM_ID)AlertTypes::ALERT_END_OF_TYPE);
#endif

    qDebug() << "JSON: Graphic Items enum:";

    foreach (const QJsonValue & value, jsonArray) { 

        QString name = value.toString();

        id++;

        //TODO verify NAME and ID are unique

        qDebug() << "name: " <<  qPrintable(name) << "id:" << id;


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
