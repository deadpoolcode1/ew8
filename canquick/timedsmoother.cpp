#include "core/types.h"
#include <QObject>
#include <QDateTime>
#include "timedsmoother.h"

//TODO: try to use time lap instead of fixed buffer length, storing the timestamps of the measures.
TimedSmoother::TimedSmoother(quint32 aSmoothingTimeInterval, quint32 aSkipSmoothingDelta)
{

    smoothingTimeInterval = (qint64)aSmoothingTimeInterval;
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

void TimedSmoother::addMeasure(quint32 measure)
{

    qint64 curTimestamp = QDateTime::currentMSecsSinceEpoch();

    if(skipSmoothingDelta > 0)
    {
        quint32 prevAverage = getAverage();
        quint32 delta = prevAverage>measure?(prevAverage - measure):(measure - prevAverage);

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
        sum -= bufferQueue.first();
        firstMeasureTimestamp = timestampsQueue.first();
        bufferQueue.pop_front();
        timestampsQueue.pop_front();
        items_count--;
    }

    items_count++;
    bufferQueue.push_back(measure);
    timestampsQueue.push_back(curTimestamp);
    sum+=measure;
}

quint32 TimedSmoother::getSmoothedValue(void)
{
   return getAverage();
}

quint32 TimedSmoother::getAverage(void)
{
    quint32 ret = 0;

    if(items_count > 0)
    {
        ret = (quint32)qRound((double)sum/items_count);
    }

    return ret; ;
}
