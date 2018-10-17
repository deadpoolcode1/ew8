#ifndef ICANRXMSGFACTORY_H
#define ICANRXMSGFACTORY_H

#include "defs.h"
#include "canrxmsg.h"

class CanRxMsg;

class ICanRxMsgFactory
{
public:
    virtual CanRxMsg * createCanRxMsgInstance(can_id_t cid) = 0;
};

#endif // ICANRXMSGFACTORY_H
