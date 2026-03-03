#ifndef IAMJSONPROCESSABLE_H
#define IAMJSONPROCESSABLE_H

#include "core/types.h"

class QObject;

class IAMJsonProcessable
{
public:
    virtual void process(QObject * sender, Variant extractedCANsignal) = 0;
    virtual bool setSupplimentary(Variant extractedCANsignal) = 0;
};

#endif // IAMJSONPROCESSABLE_H
