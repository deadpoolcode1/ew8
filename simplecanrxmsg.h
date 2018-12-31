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

     //Used for signals that just match to display alerts one-to-one
     void one2oneParseAndProcess(struct can_frame * recv, AMJsonSignal * jsonsig);

     void argumentSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig);
     void enableSignalProcess(struct can_frame * recv, AMJsonSignal * jsonsig);

     /**
      * @returns: success status
      */
     bool extractSetUnsetAction(struct can_frame * recv, AMJsonSignal * jsonsig, bool * do_active);

#if 0
     void one2oneParseAndProcess(struct can_frame * recv, const char * name, bool * flag, bool polarity = true);
#endif

};

#endif // SIMPLECANRXMSG_H
