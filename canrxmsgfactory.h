#ifndef CANRXMSGFACTORY_H
#define CANRXMSGFACTORY_H

#include "icanrxmsgfactory.h"

class ICanRxMsgFactory;

class CanRxMsgFactory: public ICanRxMsgFactory
{
public:
    CanRxMsg * createCanRxMsgInstance(can_id_t cid);
};

#endif // CANRXMSGFACTORY_H
