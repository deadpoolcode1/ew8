#ifndef GRAPHICITEMSENUMMAP_H
#define GRAPHICITEMSENUMMAP_H

#include "defs.h"
#include "core/types.h"
#include "core/mutex.h"

class GraphicItemsEnumMap
{

public:

    //TODO add exception on not found
    static DISPLAY_ITEM_ID getId(core::QString name);
    static core::QString getName(DISPLAY_ITEM_ID id);

private:

    static GraphicItemsEnumMap * getInstance(void);

    static core::Mutex instanceMutex;

    static GraphicItemsEnumMap * instance;

    void init(void);

    GraphicItemsEnumMap();

    std::unordered_map<std::string, DISPLAY_ITEM_ID> graphicItemsIDsMap;

    std::unordered_map<DISPLAY_ITEM_ID, std::string> graphicItemsNamesMap;

};

#endif // GRAPHICITEMSENUMMAP_H
