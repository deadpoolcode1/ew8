#include "canrxmsg.h"
#include "smartcanrxmsg.h"
#include "smartitem.h"

class SmartItem;


SmartCanRxMsg::SmartCanRxMsg()
{
    cid = can_id_s_adas;
    is_a_first_frame = true;
}


SmartCanRxMsg::can_msg_content_t SmartCanRxMsg::parse(struct can_frame *frame)
{
   can_msg_content_t content;

   content.msgId = frame->data[CAN_MSG_S_ADAS_M_ID_BYTE];
   content.visId = frame->data[CAN_MSG_S_ADAS_VIS_ITEM_BYTE];
   content.visUnits = (visual_item_unit_t)((frame->data[CAN_MSG_S_ADAS_PARAM_UNIT_BYTE]&CAN_MSG_S_ADAS_PARAM_UNIT_MSK)>>CAN_MSG_S_ADAS_PARAM_UNIT_SHIFT);
   content.minDurUnits = (duration_unit_t)((frame->data[CAN_MSG_S_ADAS_MINDUR_UNIT_BYTE]&CAN_MSG_S_ADAS_MINDUR_UNIT_MSK)>>CAN_MSG_S_ADAS_MINDUR_UNIT_SHIFT);
   content.maxDurUnits = (duration_unit_t)((frame->data[CAN_MSG_S_ADAS_MAXDUR_UNIT_BYTE]&CAN_MSG_S_ADAS_MAXDUR_UNIT_MSK)>>CAN_MSG_S_ADAS_MAXDUR_UNIT_SHIFT);
   content.activation = (bool)(frame->data[CAN_MSG_S_ADAS_ACTIV_BYTE]&CAN_MSG_S_ADAS_ACTIV_MSK);
   content.paramInt =  frame->data[CAN_MSG_S_ADAS_PARAM_INT_BYTE];
   content.paramFrac =  frame->data[CAN_MSG_S_ADAS_PARAM_FRAC_BYTE];
   content.minDuration =  frame->data[CAN_MSG_S_ADAS_MINDUR_BYTE];
   content.maxDuration =  frame->data[CAN_MSG_S_ADAS_MAXDUR_BYTE];

   return content;

}



void SmartCanRxMsg::process(struct can_frame * frame)
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
#endif


       //Extract Fields Block
       //NOTE: instead of previous frame of the message, previous frame of visual item is to be used.

       can_msg_content_t recv_fields = parse(frame);
       //End of extract fields block

       //TODO: visual item status structure must be generated and its state must be saved

        qDebug("Smart Can Rx Msg with VisId %d processed @%s:%d", recv_fields.visId, __func__, __LINE__);





       //Activation/Deactivation Block
       SmartItem * smarti = SmartItem::getInstance(recv_fields.visId);

       smarti->setDisplay(alertsDisplay);

#if 0
       if(!smarti->isRunning())
       {
          smarti->start();
       }
#endif

       //construct smart item settings struct:
       SmartItem::smart_params_t smart_params;

       smart_params.visUnits = recv_fields.visUnits;
       smart_params.paramInt = recv_fields.paramInt;
       smart_params.paramFrac = recv_fields.paramFrac;

       smart_params.minDurationMs = recv_fields.minDuration * (convert2msec(recv_fields.minDurUnits));
       smart_params.maxDurationMs = recv_fields.maxDuration * (convert2msec(recv_fields.maxDurUnits));

 #if 0
       alertsDisplay->mutex.lock();
#endif


       if (recv_fields.activation)
       {
           //activate
           smarti->setActive(smart_params);
       }
       else
       {
           smarti->setInactive();
       }

#if 0
       alertsDisplay->mutex.unlock();
#endif

       //End of Activation/Deactivation Block

#if 0
       memcpy(&prev_frame, frame, sizeof(struct can_frame));
   }
#endif

}


void SmartCanRxMsg::ack()
{


}

quint32 SmartCanRxMsg::convert2msec (duration_unit_t unit)
{
    quint32 ret = 0;

    for (size_t i=0; i < du_units_table_size; i++)
    {
        if (unit == du_units_table[i].unit)
        {
            ret = du_units_table[i].msec;
            i =  du_units_table_size;
        }
    }

    return ret;
}


