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

                   //byte 0
                   //Currently skipped

                   //byte 1:

               beamStateParseAndProcess(frame);

                  //byte 2:

               hmwStateParseAndProcess(frame);




               //byte 4:

               one2oneParseAndProcess(frame,"LDW_off",AlertTypes::ALERT_LDWOFF);

               one2oneParseAndProcess(frame,"LDW_off",AlertTypes::ALERT_LDWON,false);

               one2oneParseAndProcess(frame,"LLDW_on",AlertTypes::ALERT_LLDW);

               one2oneParseAndProcess(frame,"RLDW_on",AlertTypes::ALERT_RLDW);

               one2oneParseAndProcess(frame,"FCW_on",AlertTypes::ALERT_FCW);


               //byte 5:

               //TODO PCW_PedDZ

 #if 0

               //CAN_MSG_MASTER_TSREN_BYTE

               if(1 == (alertAction = alertStateParseAndCmp(preframe, frame, CAN_MSG_MASTER_TSREN_BYTE, CAN_MSG_MASTER_TSREN_MSK)))
               {
                   is_tsr_enabled = true;

               }
               else if (-1 == alertAction)
               {
                   is_tsr_enabled = false;

                   //reset active tsr alerts:
                   if(false == is_a_first_frame[can_id_tsr])
                   {
                       sliStateParseAndProcess(&prev_frame[can_id_tsr], nullptr);
                       is_a_first_frame[can_id_tsr] = true;
                   }
               }
#endif

       //End of extract fields block

       alertsDisplay->mutex.lock();
       //Activation/Deactivation Block
       qDebug("AWS Can Rx Msg with new info processed @%s:%d", __func__, __LINE__);


       //TODO set simple items

       //End of Activation/Deactivation Block
       alertsDisplay->mutex.unlock();

       memcpy(&prev_frame, frame, sizeof(struct can_frame));
   }
}


void AwsCanRxMsg::beamStateParseAndProcess(struct can_frame * recv)
{
    AlertTypes::EnAlert alert;

    alertsDisplay->deactivate(AlertTypes::ALERT_HI_BEAM);
    alertsDisplay->deactivate(AlertTypes::ALERT_LOW_BEAM);

    if(recv)
    {
        sg_var_t newFLAState = extractSignal("FLA_Armed",recv);

        if(newFLAState.sg_val._bool)
        {
        sg_var_t newBeamState = extractSignal("Hi_Low_BeamControl",recv);
        alert = newBeamState.sg_val._bool ? AlertTypes::ALERT_HI_BEAM : AlertTypes::ALERT_LOW_BEAM;
        alertsDisplay->activate(alert);
        }
    }
}

void AwsCanRxMsg::hmwStateParseAndProcess(struct can_frame * recv)
{
    bool valid = extractSignal("Headway_valid",recv).sg_val._bool;
    quint8 state;
    quint8 value;

     alertsDisplay->deactivate(AlertTypes::ALERT_HMW_MONITOR);
     alertsDisplay->deactivate(AlertTypes::ALERT_HMW_ALERT);

     if(valid && (HW_Clear != (state = extractSignal("HW_Warning_level",recv).sg_val._int)))
     {

         value = extractSignal("Headway_measurement",recv).sg_val._int;

        if(HW_Alert == state)
        {
          alertsDisplay->activate(AlertTypes::ALERT_HMW_ALERT, value);
        }
        else
        {
          alertsDisplay->activate(AlertTypes::ALERT_HMW_MONITOR, value);
        }

     }
}

void AwsCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, AlertTypes::EnAlert alert, bool polarity)
{

    bool desired = extractSignal(name,recv).sg_val._bool;

    bool do_active = (desired == polarity);

    if(do_active)
    {
         alertsDisplay->activate(alert);
    }
    else
    {
        alertsDisplay->deactivate(alert);
    }
}


