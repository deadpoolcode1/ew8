#ifndef CANSTRINGARGUMENTSACCUMULATOR_H
#define CANSTRINGARGUMENTSACCUMULATOR_H

#include "defs.h"
#include "core/types.h"
#include "core/signal.h"

#include "canargumentsaccumulator.h"

class CanArgumentsAccumulator;

class CanStringArgumentsAccumulator : public CanArgumentsAccumulator
{
public:
    static CanStringArgumentsAccumulator * getInstance(DISPLAY_ITEM_ID graphicItem);

    void insertValueFromSignal(size_t anIndex, int8_t aChar);

    virtual const char * getArgumentsTypeName() {return argumentsTypeName;}

    core::Signal<const String&> argumentComplete;

private:
    static const char * argumentsTypeName;

    CanStringArgumentsAccumulator();

    Map<size_t,char> charactersMap;
};

#endif // CANSTRINGARGUMENTSACCUMULATOR_H
