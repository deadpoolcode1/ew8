#ifndef AWSCANRXMSG_H
#define AWSCANRXMSG_H

#include "simplecanrxmsg.h"
#include "alerttypes.h"

class SimpleCanRxMsg;

class AwsCanRxMsg : public SimpleCanRxMsg
{
public:
    AwsCanRxMsg();
    void process(struct can_frame * frame);


protected:


    void beamStateParseAndProcess(struct can_frame * recv);
    void hmwStateParseAndProcess(struct can_frame * recv);



    //PCW_PedDZ (enumeration used)
    void pedAlertsParseAndProcess(struct can_frame * recv);
};

#endif // AWSCANRXMSG_H
