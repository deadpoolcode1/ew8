#include "canargumentsaccumulator.h"
#include "core/types.h"

#include <ctype.h>

Map<DISPLAY_ITEM_ID,CanArgumentsAccumulator*> CanArgumentsAccumulator::objectsMap;

CanArgumentsAccumulator::CanArgumentsAccumulator()
{
     maxIndex = -1;
}

CanArgumentsAccumulator * CanArgumentsAccumulator::getExistingInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanArgumentsAccumulator * ret = nullptr;

    auto it = objectsMap.find(graphicItem);
    if(it != objectsMap.end())
    {
         ret = it->second;
    }

    return ret;
}

void CanArgumentsAccumulator::growTriggeringSize(ssize_t anIndex)
{
    if (maxIndex < anIndex)
    {
        maxIndex = anIndex;
    }
}
