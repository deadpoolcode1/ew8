#ifndef IDISPLAYNODE_H
#define IDISPLAYNODE_H

#include "defs.h"
#include "core/types.h"

class IDisplayNode {
public:
    virtual ~IDisplayNode() = default;
    virtual void activate() = 0;
    virtual void deactivate() = 0;
    virtual int getActivSem() = 0;
    virtual void setCanEntityArgs(uint8_t valueInt, uint8_t valueFrac, uint8_t unit) = 0;
    virtual void setCanEntityArg(const String& stringArg) = 0;
};

#endif // IDISPLAYNODE_H
