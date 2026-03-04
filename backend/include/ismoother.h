#ifndef ISMOOTHER_H
#define ISMOOTHER_H

#include "core/types.h"

class ISmoother
{
public:
    virtual uint32_t getSmoothedValue(void) = 0;
    virtual void addMeasure(uint32_t measure) = 0;
};

#endif // ISMOOTHER_H
