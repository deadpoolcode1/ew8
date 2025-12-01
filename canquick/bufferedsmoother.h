#ifndef BUFFEREDSMOOTHER_H
#define BUFFEREDSMOOTHER_H

#include <QObject>
#include <QList>
#include "ismoother.h"

class ISmoother;

class BufferedSmoother: public ISmoother
{
public:
    BufferedSmoother(quint32 smoothingLength, quint32 skipSmoothingDelta);
    quint32 getSmoothedValue(void);
    void addMeasure(quint32 measure);
private:
    void cleanBuffer(void);
    quint32 getAverage(void);
    QList<quint32> bufferQueue;
    quint32 skipSmoothingDelta;
    quint32 smoothingBufferLength;
    quint32 sum;
    quint32 items_count;
};

#endif // BUFFEREDSMOOTHER_H
