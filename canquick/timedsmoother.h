#ifndef EDSMOOTHER_H
#define EDSMOOTHER_H

#include "core/types.h"
#include <QObject>
#include "ismoother.h"

class ISmoother;

class TimedSmoother: public ISmoother
{
public:
    TimedSmoother(uint32_t smoothingiTimeInterval, uint32_t skipSmoothingDelta);
    uint32_t getSmoothedValue(void);
    void addMeasure(uint32_t measure);
private:
    void cleanBuffer(void);
    uint32_t getAverage(void);
    core::QList<uint32_t> bufferQueue;
    core::QList<int64_t> timestampsQueue;
    int64_t firstMeasureTimestamp;
    uint32_t skipSmoothingDelta;
    int64_t smoothingTimeInterval;
    uint32_t sum;
    uint32_t items_count;
};

#endif // TIMEDSMOOTHER_H
