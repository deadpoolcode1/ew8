#ifndef SIMPLECANRXMSG_H
#define SIMPLECANRXMSG_H

#include "canrxmsg.h"
#include "canmanager.h"

class CanManager;

class CanRxMsg;

class SimpleCanRxMsg : public CanRxMsg
{
public:
    SimpleCanRxMsg();

    void process(struct can_frame * frame);
    void ack(CanManager *);

    void canRxJsonSignalsParseAndProcess(struct can_frame * frame);

protected:

};

#endif // SIMPLECANRXMSG_H
