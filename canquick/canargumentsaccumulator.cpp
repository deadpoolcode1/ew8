#include "canargumentsaccumulator.h"
#include "core/types.h"

#include <ctype.h>

QMap<DISPLAY_ITEM_ID,CanArgumentsAccumulator*> CanArgumentsAccumulator::objectsMap;

CanArgumentsAccumulator::CanArgumentsAccumulator(QObject *parent) : QObject(parent)
{
     maxIndex = -1;
}

CanArgumentsAccumulator * CanArgumentsAccumulator::getExistingInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanArgumentsAccumulator * ret = nullptr;

    if(objectsMap.contains(graphicItem))
    {
         ret = objectsMap.find(graphicItem).value();
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
