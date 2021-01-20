#include "canintargumentsaccumulator.h"
#include "graphicitemsenummap.h"
#include "bufferedsmoother.h"

const char* CanIntArgumentsAccumulator::argumentsTypeName = "Int";

CanIntArgumentsAccumulator::CanIntArgumentsAccumulator(CanArgumentsAccumulator *parent) : CanArgumentsAccumulator(parent)
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
        objectsMap.insert(graphicItem, ret);

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
        if(nullptr != smoother)
        {
            smoother->addMeasure((quint32)intValue[0]);
            intValue[0] = (quint8)((smoother->getSmoothedValue())&0xff);
        }

        argumentComplete(intValue[0], intValue[1], intValue[2]);




        flagValue[0]= false;
        flagValue[1]= false;
        flagValue[2]= false;
    }
}

 void CanIntArgumentsAccumulator::addSmoothingAlgorithm(BufferedSmoother * aSmoother)
 {
     smoother = aSmoother;
 }
