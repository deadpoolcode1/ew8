#include "core/types.h"
#include <QObject>
#include "bufferedsmoother.h"

//TODO: try to use time lap instead of fixed buffer length, storing the timestamps of the measures.
BufferedSmoother::BufferedSmoother(quint32 aSmoothingLength, quint32 aSkipSmoothingDelta)
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

void BufferedSmoother::addMeasure(quint32 measure)
{

    if(skipSmoothingDelta > 0)
    {
        quint32 prevAverage = getAverage();
        quint32 delta = prevAverage>measure?(prevAverage - measure):(measure - prevAverage);

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

quint32 BufferedSmoother::getSmoothedValue(void)
{
   return getAverage();
}

quint32 BufferedSmoother::getAverage(void)
{
    quint32 ret = 0;

    if(items_count > 0)
    {
        ret = (quint32)qRound((double)sum/items_count);
    }

    return ret; ;
}
