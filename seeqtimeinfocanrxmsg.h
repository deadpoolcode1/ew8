#ifndef SEEQTIMEINFOCANRXMSG_H
#define SEEQTIMEINFOCANRXMSG_H

#include "simplecanrxmsg.h"
#include "alerttypes.h"

class SeeQTimeInfoCanRxMsg : public SimpleCanRxMsg
{
public:
    SeeQTimeInfoCanRxMsg();
    void process(struct can_frame * frame);
};

#endif // SEEQTIMEINFOCANRXMSG_H
