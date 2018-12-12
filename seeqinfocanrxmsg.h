#ifndef SEEQINFOCANRXMSG_H
#define SEEQINFOCANRXMSG_H

#include "simplecanrxmsg.h"
#include "alerttypes.h"

class SeeQInfoCanRxMsg : public SimpleCanRxMsg
{
public:
    SeeQInfoCanRxMsg();
    void process(struct can_frame * frame);
};

#endif // SEEQINFOCANRXMSG_H
