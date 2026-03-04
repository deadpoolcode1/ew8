#ifndef CANRXMSGFACTORY_H
#define CANRXMSGFACTORY_H

#include "icanrxmsgfactory.h"

class ICanRxMsgFactory;

class CanRxMsgFactory: public ICanRxMsgFactory
{
public:
    CanRxMsg * createCanRxMsgInstance(CanStdId_t StdId);
};

#endif // CANRXMSGFACTORY_H
