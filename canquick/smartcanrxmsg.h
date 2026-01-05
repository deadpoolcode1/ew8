#ifndef SMARTCANRXMSG_H
#define SMARTCANRXMSG_H

#include "canrxmsg.h"
#include "smartitem.h"

#include "canmanager.h"

class CanManager;

class CanRxMsg;

class SmartCanRxMsg : public CanRxMsg
{
public:
    SmartCanRxMsg();

    void process(struct can_frame * frame);
    void ack(CanManager * canMngr);


protected:

    typedef struct can_msg_content_s{
     uint8_t msgId;
     uint8_t visId;
     visual_item_unit_t visUnits;
     duration_unit_t minDurUnits;
     duration_unit_t maxDurUnits;
     bool activation;
     uint8_t paramInt;
     uint8_t paramFrac;
     uint8_t minDuration;
     uint8_t maxDuration;
    } can_msg_content_t;


    can_msg_content_t parse(struct can_frame *frame);

     uint32_t convert2msec (duration_unit_t unit);

private:

     can_msg_content_t recv_fields;


};

#endif // SMARTCANRXMSG_H
