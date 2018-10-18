#ifndef AWSCANRXMSG_H
#define AWSCANRXMSG_H

#include "simplecanrxmsg.h"

class SimpleCanRxMsg;

class AwsCanRxMsg : public SimpleCanRxMsg
{
public:
    AwsCanRxMsg();
    void process(struct can_frame * frame);
};

#endif // AWSCANRXMSG_H
