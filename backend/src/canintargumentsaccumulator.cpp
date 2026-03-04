#include "canintargumentsaccumulator.h"
#include "graphicitemsenummap.h"
#include "bufferedsmoother.h"

const char* CanIntArgumentsAccumulator::argumentsTypeName = "Int";

CanIntArgumentsAccumulator::CanIntArgumentsAccumulator() : CanArgumentsAccumulator()
{
   flagValue[0] = false;
   flagValue[1] = false;
   flagValue[2] = false;
   smoother = nullptr;
}


CanIntArgumentsAccumulator * CanIntArgumentsAccumulator::getInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanIntArgumentsAccumulator * ret = nullptr;

    CanArgumentsAccumulator * generalInstance;

    if(nullptr == (generalInstance = getExistingInstance(graphicItem)))
    {
        ret = new CanIntArgumentsAccumulator();
#if 0
        ret->doArgSmoothing = (graphicItem == GraphicItemsEnumMap::getId("INFO_VEH_SPEED"));
#endif
        objectsMap[graphicItem] = ret;

 #if 0
        if(ret->doArgSmoothing){
             ret->smoother = new BufferedSmoother(20, 5);
        }
#endif

    }
    else if (generalInstance->getArgumentsTypeName() == argumentsTypeName)
    {
        ret = (CanIntArgumentsAccumulator *) generalInstance;
    }

    return ret;
}


void CanIntArgumentsAccumulator::insertValueFromSignal(size_t anIndex, int8_t anArg)
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
        if(nullptr != smoother)
        {
            smoother->addMeasure((uint32_t)intValue[0]);
            intValue[0] = (uint8_t)((smoother->getSmoothedValue())&0xff);
        }

        argumentComplete.fire(intValue[0], intValue[1], intValue[2]);




        flagValue[0]= false;
        flagValue[1]= false;
        flagValue[2]= false;
    }
}

 void CanIntArgumentsAccumulator::addSmoothingAlgorithm(ISmoother * aSmoother)
 {
     smoother = aSmoother;
 }
