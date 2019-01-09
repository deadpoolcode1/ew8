#ifndef ICANRXMSGFACTORY_H
#define ICANRXMSGFACTORY_H

#include "defs.h"
#include "canrxmsg.h"
#include "amsignalsmodel.h"

class CanRxMsg;

class ICanRxMsgFactory
{
public:
    virtual CanRxMsg * createCanRxMsgInstance(can_id_t cid, AMSignalsModel * model) = 0;
};

#endif // ICANRXMSGFACTORY_H
