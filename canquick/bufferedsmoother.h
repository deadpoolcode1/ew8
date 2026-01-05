#ifndef BUFFEREDSMOOTHER_H
#define BUFFEREDSMOOTHER_H

#include "core/types.h"
#include <QObject>
#include "ismoother.h"

class ISmoother;

class BufferedSmoother: public ISmoother
{
public:
    BufferedSmoother(uint32_t smoothingLength, uint32_t skipSmoothingDelta);
    uint32_t getSmoothedValue(void);
    void addMeasure(uint32_t measure);
private:
    void cleanBuffer(void);
    uint32_t getAverage(void);
    QList<uint32_t> bufferQueue;
    uint32_t skipSmoothingDelta;
    uint32_t smoothingBufferLength;
    uint32_t sum;
    uint32_t items_count;
};

#endif // BUFFEREDSMOOTHER_H
