#ifndef CANINTARGUMENTSACCUMULATOR_H
#define CANINTARGUMENTSACCUMULATOR_H

#include "canargumentsaccumulator.h"
#include "ismoother.h"
#include "core/types.h"
#include "core/signal.h"

class CanArgumentsAccumulator;

class CanIntArgumentsAccumulator : public CanArgumentsAccumulator
{
public:

    static CanIntArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}

    void insertValueFromSignal(size_t anIndex, int8_t anArg);

    void addSmoothingAlgorithm(ISmoother * aSmoother);

    core::Signal<uint8_t, uint8_t, uint8_t> argumentComplete;

private:
    static const char * argumentsTypeName;
    ISmoother * smoother;

    CanIntArgumentsAccumulator();

    uint8_t intValue[3];
    bool flagValue[3];
    bool doArgSmoothing;

    //TODO replace with circular buffer
    uint32_t speedSmoothingBufferLength;
    List<uint8_t> smoothedArgBuffer;
};

#endif // CANINTARGUMENTSACCUMULATOR_H
