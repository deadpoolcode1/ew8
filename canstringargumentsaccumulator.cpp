#include "canstringargumentsaccumulator.h"
#include "canargumentsaccumulator.h"
#include "core/types.h"

#include <ctype.h>

const char * CanStringArgumentsAccumulator::argumentsTypeName = "String";

CanStringArgumentsAccumulator::CanStringArgumentsAccumulator() : CanArgumentsAccumulator()
{}

CanStringArgumentsAccumulator * CanStringArgumentsAccumulator::getInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanStringArgumentsAccumulator * ret = nullptr;

    CanArgumentsAccumulator * generalInstance;

    if(nullptr == (generalInstance = getExistingInstance(graphicItem)))
    {
        ret = new CanStringArgumentsAccumulator();
        objectsMap[graphicItem] = ret;
    }
    else if (generalInstance->getArgumentsTypeName() == argumentsTypeName)
    {
        ret = (CanStringArgumentsAccumulator *) generalInstance;
    }


    return ret;
}


void CanStringArgumentsAccumulator::insertValueFromSignal(size_t anIndex, int8_t aChar)
{

    String * result =   nullptr;

    if(!isprint(aChar))
    {
        aChar = 'X';
    }

    charactersMap[anIndex] = (char)aChar;

    if ((maxIndex +1)== (ssize_t)charactersMap.size())
    {
        char ch_result[maxIndex+2];

        ch_result[maxIndex+1] = '\0';

        for (ssize_t i = 0; i < (maxIndex+1); i++)
        {
            ch_result[i] = charactersMap[i];
        }

        result = new String(ch_result);

        argumentComplete.fire(*result);

        charactersMap.clear();
    }

}
