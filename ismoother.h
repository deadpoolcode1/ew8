#ifndef ISMOOTHER_H
#define ISMOOTHER_H

#include <QObject>
#include <QList>

class ISmoother
{
public:
    virtual quint32 getSmoothedValue(void) = 0;
    virtual void addMeasure(quint32 measure) = 0;
};

#endif // ISMOOTHER_H
