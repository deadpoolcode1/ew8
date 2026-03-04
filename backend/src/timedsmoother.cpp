#include "core/types.h"
#include "core/elapsed_timer.h"
#include <cmath>
#include "timedsmoother.h"

//TODO: try to use time lap instead of fixed buffer length, storing the timestamps of the measures.
TimedSmoother::TimedSmoother(uint32_t aSmoothingTimeInterval, uint32_t aSkipSmoothingDelta)
{

    smoothingTimeInterval = (int64_t)aSmoothingTimeInterval;
    skipSmoothingDelta = aSkipSmoothingDelta;
    sum = 0;
    items_count = 0;
}

void TimedSmoother::cleanBuffer(void)
{
    sum = 0;
    items_count = 0;
    bufferQueue.clear();
    timestampsQueue.clear();
}

void TimedSmoother::addMeasure(uint32_t measure)
{

    int64_t curTimestamp = core::ElapsedTimer::currentMSecsSinceEpoch();

    if(skipSmoothingDelta > 0)
    {
        uint32_t prevAverage = getAverage();
        uint32_t delta = prevAverage>measure?(prevAverage - measure):(measure - prevAverage);

        if(delta > skipSmoothingDelta)
        {
            cleanBuffer();
        }
    }

    if(items_count == 0)
    {
       firstMeasureTimestamp = curTimestamp;
    }

    while((items_count > 0) && ((curTimestamp - firstMeasureTimestamp) > smoothingTimeInterval))
    {
        sum -= bufferQueue.front();
        firstMeasureTimestamp = timestampsQueue.front();
        bufferQueue.erase(bufferQueue.begin());
        timestampsQueue.erase(timestampsQueue.begin());
        items_count--;
    }

    items_count++;
    bufferQueue.push_back(measure);
    timestampsQueue.push_back(curTimestamp);
    sum+=measure;
}

uint32_t TimedSmoother::getSmoothedValue(void)
{
   return getAverage();
}

uint32_t TimedSmoother::getAverage(void)
{
    uint32_t ret = 0;

    if(items_count > 0)
    {
        ret = (uint32_t)std::lround((double)sum/items_count);
    }

    return ret; ;
}
