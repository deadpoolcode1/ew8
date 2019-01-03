#include "canstringargumentsaccumulator.h"

#include <QMap>

#include <QStringBuilder>

#include <ctype.h>

QMap<DISPLAY_ITEM_ID,CanStringArgumentsAccumulator*> CanStringArgumentsAccumulator::objectsMap;

CanStringArgumentsAccumulator::CanStringArgumentsAccumulator(QObject *parent) : QObject(parent)
{
     maxIndex = -1;
}

CanStringArgumentsAccumulator * CanStringArgumentsAccumulator::getInstance(DISPLAY_ITEM_ID graphicItem)
{

    CanStringArgumentsAccumulator * ret = nullptr;

    if(objectsMap.contains(graphicItem))
    {
         ret = objectsMap.find(graphicItem).value();
    }
    else
    {
      ret = new CanStringArgumentsAccumulator();
      objectsMap.insert(graphicItem, ret);
    }

    return ret;
}

void CanStringArgumentsAccumulator::growTriggeringSize(ssize_t anIndex)
{
    if (maxIndex < anIndex)
    {
        maxIndex = anIndex;
    }

}

void CanStringArgumentsAccumulator::insertCharFromSignal(size_t anIndex, char aChar)
{

    QString * result =   nullptr;

    if(!isalnum(aChar))
    {
        aChar = 'X';
    }

    charactersMap.insert(anIndex, aChar);

    if ((maxIndex +1)== charactersMap.count())
    {
        char ch_result[maxIndex+2];

        ch_result[maxIndex+1] = '\0';

        for (ssize_t i = 0; i < (maxIndex+1); i++)
        {
            ch_result[i] = charactersMap[i];
        }

        result = new QString(ch_result);

        argumentComplete(*result);

        charactersMap.clear();
    }

}
