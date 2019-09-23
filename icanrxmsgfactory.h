#ifndef ICANRXMSGFACTORY_H
#define ICANRXMSGFACTORY_H

#include "defs.h"
#include "canrxmsg.h"
#include "amsignalsmodel.h"

class CanRxMsg;

class ICanRxMsgFactory
{
public:
    virtual CanRxMsg * createCanRxMsgInstance(CanStdId_t StdId, AMSignalsModel * model) = 0;
};

#endif // ICANRXMSGFACTORY_H
