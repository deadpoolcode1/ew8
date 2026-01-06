#ifndef CANINTARGUMENTSACCUMULATOR_H
#define CANINTARGUMENTSACCUMULATOR_H

#include "core/types.h"
#include "canargumentsaccumulator.h"
#include "ismoother.h"

#include <QObject>

class CanArgumentsAccumulator;

class CanIntArgumentsAccumulator : public CanArgumentsAccumulator
{
    Q_OBJECT
public:


    static CanIntArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}

    void insertValueFromSignal(size_t anIndex, int8_t anArg);

    void addSmoothingAlgorithm(ISmoother * aSmoother);


private:
    static const char * argumentsTypeName;
    ISmoother * smoother;

     explicit CanIntArgumentsAccumulator(CanArgumentsAccumulator *parent = nullptr);

    uint8_t intValue[3];
    bool flagValue[3];
    bool doArgSmoothing;

    //TODO replace with circular buffer
    uint32_t speedSmoothingBufferLength;
    core::QList<uint8_t> smoothedArgBuffer;


signals:

    void argumentComplete(uint8_t intValue, uint8_t fracValue, uint8_t unitValue);

public slots:
};

#endif // CANINTARGUMENTSACCUMULATOR_H
