#include "graphicitemsenummap.h"

#include "amjsonconfigreader.h"

#include "defs.h"

#include "alerttypes_core.h"

#include "entitytype.h"

#include "core/json.h"
#include "core/core.h"

core::Mutex GraphicItemsEnumMap::instanceMutex;

GraphicItemsEnumMap * GraphicItemsEnumMap::instance;

GraphicItemsEnumMap::GraphicItemsEnumMap()
{
   init();
}

DISPLAY_ITEM_ID GraphicItemsEnumMap::getId(const String& name)
{

    GraphicItemsEnumMap * myInstance = getInstance();

    auto it = myInstance->graphicItemsIDsMap.find(name);
    DISPLAY_ITEM_ID ret = (it != myInstance->graphicItemsIDsMap.end()) ? it->second : (DISPLAY_ITEM_ID)AlertTypes::ALERT_NONE;

    return ret;
}

String GraphicItemsEnumMap::getName(DISPLAY_ITEM_ID id)
{
    GraphicItemsEnumMap * myInstance = getInstance();

    auto it = myInstance->graphicItemsNamesMap.find(id);
    String ret = (it != myInstance->graphicItemsNamesMap.end()) ? it->second : "";

    return ret;
}

void GraphicItemsEnumMap::init(void)
{
     core::JsonArray jsonArray = AMJsonConfigReader::getInstance()->getJsonTopEntry("GraphicItems").toArray();

    DISPLAY_ITEM_ID id;

#ifdef DYNAMIC_DISPLAY_ITEM_ID
    id =  ((DISPLAY_ITEM_ID)AlertTypes::ALERT_END_OF_TYPE);
#endif

    coreDebug() << "JSON: Graphic Items enum:";

    for (const core::JsonValue& value : jsonArray) {

        std::string name = value.toString();

        id++;

        //TODO verify NAME and ID are unique

        coreDebug() << "name: " <<  name.c_str() << "id:" << id;


        graphicItemsIDsMap[name] = id;
        graphicItemsNamesMap[id] = name;


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
