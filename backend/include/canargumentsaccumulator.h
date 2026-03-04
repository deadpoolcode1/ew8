#ifndef CANARGUMENTSACCUMULATOR_H
#define CANARGUMENTSACCUMULATOR_H

#include "defs.h"
#include "core/types.h"

class CanArgumentsAccumulator
{
public:
    static CanArgumentsAccumulator * getExistingInstance(DISPLAY_ITEM_ID graphicItem);

    void growTriggeringSize(ssize_t index);

    virtual const char * getArgumentsTypeName() = 0;

    virtual void insertValueFromSignal(size_t anIndex, int8_t anArg) = 0;

protected:
    CanArgumentsAccumulator();
    static Map<DISPLAY_ITEM_ID,CanArgumentsAccumulator*> objectsMap;

    ssize_t maxIndex;
};

#endif // CANARGUMENTSACCUMULATOR_H
