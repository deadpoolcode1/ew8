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
    void argumentSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig);

protected:
     SimpleCanRxMsg();

     //Used for signals that just match to display alerts one-to-one
     void one2oneParseAndProcess(struct can_frame * recv, const char * name, DISPLAY_ITEM_ID alert, bool polarity = true);

     void one2oneParseAndProcess(struct can_frame * recv, const char * name, bool * flag, bool polarity = true);

};

#endif // SIMPLECANRXMSG_H
