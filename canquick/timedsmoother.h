#ifndef EDSMOOTHER_H
#define EDSMOOTHER_H

#include "core/types.h"
#include <QObject>
#include "ismoother.h"

class ISmoother;

class TimedSmoother: public ISmoother
{
public:
    TimedSmoother(quint32 smoothingiTimeInterval, quint32 skipSmoothingDelta);
    quint32 getSmoothedValue(void);
    void addMeasure(quint32 measure);
private:
    void cleanBuffer(void);
    quint32 getAverage(void);
    QList<quint32> bufferQueue;
    QList<qint64> timestampsQueue;
    qint64 firstMeasureTimestamp;
    quint32 skipSmoothingDelta;
    qint64 smoothingTimeInterval;
    quint32 sum;
    quint32 items_count;
};

#endif // TIMEDSMOOTHER_H
