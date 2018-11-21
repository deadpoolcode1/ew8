#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "awscanrxmsg.h"

AwsCanRxMsg::AwsCanRxMsg()
{
    cid = can_id_master;
}

AwsCanRxMsg::can_msg_content_t AwsCanRxMsg::parse(struct can_frame *frame)
{
    can_msg_content_t content;

    //TODO replace with array defined mechanism

    content.sound_type = (frame->data[CAN_MSG_MASTER_SOUND_BYTE]) & CAN_MSG_MASTER_SOUND_TYPE_MSK;
    content.time_indicator = ((frame->data[CAN_MSG_MASTER_TIME_IND_BYTE]) & CAN_MSG_MASTER_TIME_IND_MSK)>>CAN_MSG_MASTER_TIME_IND_SHIFT;
    content.sound_repeat = ((frame->data[CAN_MSG_MASTER_SOUND_BYTE]) & CAN_MSG_MASTER_SND_REP_MSK)>>CAN_MSG_MASTER_SND_REP_SHIFT;
    content.sound_suppressed = ((frame->data[CAN_MSG_MASTER_SOUND_BYTE] & CAN_MSG_MASTER_SND_SUPPRESSED_MSK)? true : false);

    content.secondary_diagnoctic = (frame->data[CAN_MSG_MASTER_SEC_DIAG_BYTE]) & CAN_MSG_MASTER_SEC_DIAG_MSK;
    content.zero_speed = ((frame->data[CAN_MSG_MASTER_ZERO_SPEED_BYTE]) & CAN_MSG_MASTER_ZERO_SPEED_MSK) ? true : false;
    content.hi_low_beam_control = ((frame->data[CAN_MSG_MASTER_BEAM_BYTE]) & CAN_MSG_MASTER_BEAM_MSK) ? true : false;
    content.fla_armed = ((frame->data[CAN_MSG_MASTER_FLA_BYTE])&CAN_MSG_MASTER_FLA_MSK) ? true : false;

    content.head_way_valid = ((frame->data[CAN_MSG_MASTER_HMWEN_BYTE]) & CAN_MSG_MASTER_HMWEN_MSK) ? true : false;
    content.headway_measurement = ((frame->data[CAN_MSG_MASTER_HMW_BYTE]) & CAN_MSG_MASTER_HMW_MSK) >> CAN_MSG_MASTER_HMW_SHIFT;

    content.error_active = ((frame->data[CAN_MSG_MASTER_ERR_ACT_BYTE]) & CAN_MSG_MASTER_ERR_ACT_MSK) ? true : false;
    content.error_code = ((frame->data[CAN_MSG_MASTER_ERR_CODE_BYTE]) & CAN_MSG_MASTER_ERR_CODE_MSK) >> CAN_MSG_MASTER_ERR_CODE_SHIFT;

    content.ldw_off = ((frame->data[CAN_MSG_MASTER_LDW_OFF_BYTE]) & CAN_MSG_MASTER_LDW_OFF_MSK) ? true : false;
    content.lldw_on = ((frame->data[CAN_MSG_MASTER_LLDW_BYTE]) & CAN_MSG_MASTER_LLDW_MSK) ? true : false;
    content.rldw_on = ((frame->data[CAN_MSG_MASTER_RLDW_BYTE]) & CAN_MSG_MASTER_RLDW_MSK) ? true : false;
    content.fcw_on =  ((frame->data[CAN_MSG_MASTER_FCW_BYTE]) & CAN_MSG_MASTER_FCW_MSK) ? true : false;
    content.maintenance = ((frame->data[CAN_MSG_MASTER_MNTC_BYTE]) & CAN_MSG_MASTER_MNTC_MSK) ? true : false;
    content.fail_safe = ((frame->data[CAN_MSG_MASTER_FLSAFE_BYTE]) & CAN_MSG_MASTER_FLSAFE_MSK) ? true : false;

    content.ped_dz = ((frame->data[CAN_MSG_MASTER_PDZ_BYTE]) & CAN_MSG_MASTER_PDZ_MSK) ? true : false;
    content.pcw = ((frame->data[CAN_MSG_MASTER_PCW_BYTE]) & CAN_MSG_MASTER_PCW_MSK) ? true : false;
    content.blinker_reminder = ((frame->data[CAN_MSG_MASTER_BLINKERS_BYTE]) & CAN_MSG_MASTER_BLINKERS_MSK) ? true : false;
    content.cyclist = ((frame->data[CAN_MSG_MASTER_CYCLIST_BYTE]) & CAN_MSG_MASTER_CYCLIST_MSK) ? true : false;
    content.tamper = ((frame->data[CAN_MSG_MASTER_TAMPER_BYTE]) & CAN_MSG_MASTER_TAMPER_MSK) ? true : false;
    content.speed_format = ((frame->data[CAN_MSG_MASTER_SPEED_FMT_BYTE]) & CAN_MSG_MASTER_SPEED_FMT_MSK) ? true : false;
    content.tsr_enabled = ((frame->data[CAN_MSG_MASTER_TSREN_BYTE]) & CAN_MSG_MASTER_TSREN_MSK) ? true : false;

    content.tsr_warning_level = ((frame->data[CAN_MSG_MASTER_TSR_WRNLEV_BYTE]) & CAN_MSG_MASTER_TSR_WRNLEV_MSK); 
    content.failsafe_level = ((frame->data[CAN_MSG_MASTER_FLSAFE_LEV_BYTE]) & CAN_MSG_MASTER_FLSAFE_LEV_MSK) >> CAN_MSG_MASTER_FLSAFE_LEV_SHIFT; 
#if 0
    content.fcw_x_active = frame->data[CAN_MSG_MASTER_FLA_BYTE];
#endif

    content.headway_warning_level = ((frame->data[CAN_MSG_MASTER_HW_LEVEL_BYTE]) & CAN_MSG_MASTER_HW_LEVEL_MSK) >>  CAN_MSG_MASTER_HW_LEVEL_SHIFT; 
    content.hw_repeatable_enabled = ((frame->data[CAN_MSG_MASTER_HW_REPEN_BYTE]) & CAN_MSG_MASTER_HW_REPEN_MSK) ? true : false;
#if 0
    content.pcw_x_active = frame->data[CAN_MSG_MASTER_FLA_BYTE];
#endif

    return content;
}

void AwsCanRxMsg::process(struct can_frame * frame)
{
#if 0
    //Overall frame compare
    bool is_frame_updated = false;

    //WARNING the first received frame is "preceeded" by a NULL frame
    struct can_frame * preframe = nullptr;

    //TODO update timeout timer? where should it be?

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
       //Extract Fields Block
       if(preframe)
       {
           can_msg_content_t prev_fields = parse(preframe);
       }

       can_msg_content_t recv_fields = parse(frame);
       //End of extract fields block

       alertsDisplay->mutex.lock();
       //Activation/Deactivation Block
       qDebug("AWS Can Rx Msg with new info processed @%s:%d", __func__, __LINE__);


       //TODO set simple items

       //End of Activation/Deactivation Block
       alertsDisplay->mutex.unlock();

       memcpy(&prev_frame, frame, sizeof(struct can_frame));
   }
#endif
}


