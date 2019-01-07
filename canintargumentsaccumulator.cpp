#include "canintargumentsaccumulator.h"

const char* CanIntArgumentsAccumulator::argumentsTypeName = "Int";

CanIntArgumentsAccumulator::CanIntArgumentsAccumulator(CanArgumentsAccumulator *parent) : CanArgumentsAccumulator(parent)
{
   flagValue[0] = false;
   flagValue[1] = false;
   flagValue[2] = false;
}


CanIntArgumentsAccumulator * CanIntArgumentsAccumulator::getInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanIntArgumentsAccumulator * ret = nullptr;

    CanArgumentsAccumulator * generalInstance;

    if(nullptr == (generalInstance = getExistingInstance(graphicItem)))
    {
        ret = new CanIntArgumentsAccumulator();
        objectsMap.insert(graphicItem, ret);
    }
    else if (generalInstance->getArgumentsTypeName() == argumentsTypeName)
    {
        ret = (CanIntArgumentsAccumulator *) generalInstance;
    }

    return ret;
}


void CanIntArgumentsAccumulator::insertValueFromSignal(size_t anIndex, qint8 anArg)
{

    intValue[anIndex] = anArg;

    flagValue[anIndex] = true;

    bool is_complete = true;

    for(ssize_t i = 0 ; i <= maxIndex; i++)
    {
        if(!flagValue[i])
        {
            is_complete = false;
        }
    }

    if(is_complete)
    {
        argumentComplete(intValue[0], intValue[1], intValue[2]);

        flagValue[0]= false;
        flagValue[1]= false;
        flagValue[2]= false;
    }
}
