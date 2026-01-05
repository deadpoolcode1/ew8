#include "core/types.h"
#include <QObject>
#include "bufferedsmoother.h"

//TODO: try to use time lap instead of fixed buffer length, storing the timestamps of the measures.
BufferedSmoother::BufferedSmoother(uint32_t aSmoothingLength, uint32_t aSkipSmoothingDelta)
{

    smoothingBufferLength = aSmoothingLength;
    skipSmoothingDelta = aSkipSmoothingDelta;
    sum = 0;
    items_count = 0;
}

void BufferedSmoother::cleanBuffer(void)
{
    sum = 0;
    items_count = 0;
    bufferQueue.clear();
}

void BufferedSmoother::addMeasure(uint32_t measure)
{

    if(skipSmoothingDelta > 0)
    {
        uint32_t prevAverage = getAverage();
        uint32_t delta = prevAverage>measure?(prevAverage - measure):(measure - prevAverage);

        if(delta > skipSmoothingDelta)
        {
            cleanBuffer();
        }
    }

    if(items_count == smoothingBufferLength)
    {
        sum -= bufferQueue.first();
        bufferQueue.pop_front();
    }
    else
    {
        items_count++;
    }

    bufferQueue.push_back(measure);
    sum+=measure;
}

uint32_t BufferedSmoother::getSmoothedValue(void)
{
   return getAverage();
}

uint32_t BufferedSmoother::getAverage(void)
{
    uint32_t ret = 0;

    if(items_count > 0)
    {
        ret = (uint32_t)qRound((double)sum/items_count);
    }

    return ret; ;
}
