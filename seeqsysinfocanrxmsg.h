#ifndef SEEQSYSINFOCANRXMSG_H
#define SEEQSYSINFOCANRXMSG_H

#include "simplecanrxmsg.h"
#include "alerttypes.h"

class SeeQSysInfoCanRxMsg : public SimpleCanRxMsg
{
public:
    SeeQSysInfoCanRxMsg();
    void process(struct can_frame * frame);
};

#endif // SEEQSYSINFOCANRXMSG_H
