#ifndef SIMPLECANRXMSG_H
#define SIMPLECANRXMSG_H

#include "canrxmsg.h"

class CanRxMsg;

class SimpleCanRxMsg : public CanRxMsg
{
public:

    virtual void process(struct can_frame * frame) = 0;
    void ack(void);

protected:
     SimpleCanRxMsg();
};

#endif // SIMPLECANRXMSG_H
