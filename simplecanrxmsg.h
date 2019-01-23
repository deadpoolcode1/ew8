#ifndef SIMPLECANRXMSG_H
#define SIMPLECANRXMSG_H

#include "canrxmsg.h"
#include "canmanager.h"

class CanManager;

class CanRxMsg;

class SimpleCanRxMsg : public CanRxMsg
{
public:

    virtual void process(struct can_frame * frame) = 0;
    void ack(CanManager *);

    void canRxJsonSignalsParseAndProcess(struct can_frame * frame);


protected:
     SimpleCanRxMsg();
};

#endif // SIMPLECANRXMSG_H
