#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "awscanrxmsg.h"

AwsCanRxMsg::AwsCanRxMsg()
{
    cid = can_id_master;
}

void AwsCanRxMsg::process(struct can_frame * frame)

{
#if 0
    //Overall frame compare
    bool is_frame_updated = false;

    //WARNING the first received frame is "preceeded" by a NULL frame
    struct can_frame * preframe = nullptr;

    if (is_a_first_frame)
    {
        is_a_first_frame = false;
    }
    else
    {
        preframe = &prev_frame;
    }

    if (preframe)
    {
        if (0 != memcmp(preframe, frame, sizeof(struct can_frame)))
        {
            is_frame_updated = true;
        }
    }
    else
    {
        is_frame_updated = true;
    }
    //End of overall frame compare



   if(!is_frame_updated)
   {
       //skip
   }
   else
   {

       qint32 alertAction;

       //Extract Fields Block
       if(preframe)
       {
            can_msg_content_t prev_fields = parse(preframe);
       }

       can_msg_content_t recv_fields = parse(frame);
       //End of extract fields block

       //Compare fields:




      //End of fields comparison

       alertsDisplay->mutex.lock();

       //Activation/Deactivation Block

       if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LDW_OFF_BYTE, CAN_MSG_MASTER_LDW_OFF_MSK)))
       {
           mydisplays->activate(AlertTypes::ALERT_LDWOFF);
       }
       else if (-1 == alertAction)
       {
           mydisplays->deactivate(AlertTypes::ALERT_LDWOFF);
       }

       //Inverted from previous
       if(-(1) == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LDW_OFF_BYTE, CAN_MSG_MASTER_LDW_OFF_MSK)))
       {
           mydisplays->activate(AlertTypes::ALERT_LDWON);
       }
       else if (-(-1) == alertAction)
       {
           mydisplays->deactivate(AlertTypes::ALERT_LDWON);
       }


       if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_LLDW_BYTE, CAN_MSG_MASTER_LLDW_MSK)))
       {
           mydisplays->activate(AlertTypes::ALERT_LLDW);
       }
       else if (-1 == alertAction)
       {
           mydisplays->deactivate(AlertTypes::ALERT_LLDW);
       }

       //End of Activation/Deactivation Block
       alertsDisplay->mutex.unlock();

       memcpy(&prev_frame, frame, sizeof(struct can_frame));
   }
#endif
}


