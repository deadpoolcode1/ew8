#include "canrxmsg.h"
#include "smartcanrxmsg.h"
#include "smartitem.h"
#include "candbsignal.h"

#include "canmanager.h"

class CanManager;

class SmartItem;


SmartCanRxMsg::SmartCanRxMsg()
{
    setCanID(can_id_s_adas);

    //TODO: find if needed?
    is_a_first_frame = true;
}


SmartCanRxMsg::can_msg_content_t SmartCanRxMsg::parse(struct can_frame *frame)
{
   can_msg_content_t content;

   content.msgId = extractSignal("Message_serial_ID",frame).sg_val._int;
   content.visId = extractSignal("Visual_Item_ID",frame).sg_val._int;
   content.visUnits = (visual_item_unit_t)extractSignal("Float_parameter_unit",frame).sg_val._int;
   content.minDurUnits = (duration_unit_t)extractSignal("Min_duration_unit",frame).sg_val._int;
   content.maxDurUnits = (duration_unit_t)extractSignal("Max_duration_unit",frame).sg_val._int;
   content.activation = extractSignal("Activation_Flag",frame).sg_val._bool;
   content.paramInt = extractSignal("Float_parameter_int",frame).sg_val._int;
   content.paramFrac =  extractSignal("Float_parameter_frac",frame).sg_val._int;
   content.minDuration =  extractSignal("Min_duration_display",frame).sg_val._int;
   content.maxDuration =  extractSignal("Max_duration_display",frame).sg_val._int;

   return content;

}



void SmartCanRxMsg::process(struct can_frame * frame)
{
       //Extract Fields Block
       //NOTE: instead of previous frame of the message, previous frame of visual item is to be used.

       recv_fields = parse(frame);
       //End of extract fields block

       //TODO: visual item status structure must be generated and its state must be saved

        qDebug("Smart Can Rx Msg with VisId %d processed @%s:%d", recv_fields.visId, __func__, __LINE__);


       //Activation/Deactivation Block
       SmartItem * smarti = SmartItem::getInstance(recv_fields.visId);

       smarti->setDisplay(itsJsonProtocol->itsModel->getItsCanManager()->getItsDisplay());


       SmartItem::smart_params_t smart_params;

       //construct smart item settings struct:
       smart_params.visUnits = recv_fields.visUnits;
       smart_params.paramInt = recv_fields.paramInt;
       smart_params.paramFrac = recv_fields.paramFrac;

       smart_params.minDurationMs = recv_fields.minDuration * (convert2msec(recv_fields.minDurUnits));
       smart_params.maxDurationMs = recv_fields.maxDuration * (convert2msec(recv_fields.maxDurUnits));


       if (recv_fields.activation)
       {
           //activate
           smarti->setActive(smart_params);
       }
       else
       {
           smarti->setInactive();
       }

       //End of Activation/Deactivation Block
}


void SmartCanRxMsg::ack(CanManager * canMngr)
{
    //TODO construct using DBC
    struct can_frame frame_to_send;


    frame_to_send.can_id = 0x7ad;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = recv_fields.msgId;
    frame_to_send.data[1] = recv_fields.visId;
    frame_to_send.data[2] = 0x0;
    frame_to_send.data[3] = recv_fields.activation? 0x1: 0x0;
    frame_to_send.data[4] = 0x0;
    frame_to_send.data[5] = 0x0;
    frame_to_send.data[6] = 0x0;
    frame_to_send.data[7] = 0x0;

    canMngr->write_frame(&frame_to_send);

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


