#ifndef ISMOOTHER_H
#define ISMOOTHER_H

#include "core/types.h"
#include <QObject>

class ISmoother
{
public:
    virtual quint32 getSmoothedValue(void) = 0;
    virtual void addMeasure(quint32 measure) = 0;
};

#endif // ISMOOTHER_H
