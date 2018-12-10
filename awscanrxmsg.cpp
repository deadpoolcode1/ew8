#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "awscanrxmsg.h"
#include "tsrcanrxmsg.h"

#include "amsignalsmodel.h"
#include "amjsonprotocol.h"
#include "candbsignal.h"

AwsCanRxMsg::AwsCanRxMsg()
{
    cid = can_id_master;
    itsJsonProtocol =  AMSignalsModel::getInstance()->getProtocol("Aftermarket");
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
               pedAlertsParseAndProcess(frame);

               bool is_enabled;
               one2oneParseAndProcess(frame, "TSR_enabbled",&is_enabled);

               if(is_enabled)
               {
                   TsrCanRxMsg::enable();
               }
               else
               {
                   TsrCanRxMsg::disable();
               }

               //TODO for over all [unparsed] signals in message:


               for (size_t i = 0; i < SignalsOfAfterMarket_AWS_0x700_size; i++)
               {

                   //JSON Driven Alerts Triggering:


                   QString currSignalStr = SignalsOfAfterMarket_AWS_0x700[i].name;

                   AMJsonSignal * jsonsig = itsJsonProtocol->getSignal(currSignalStr);

                   if(nullptr != jsonsig)
                   {

                       if(AMJsonSignal::GraphicItem == jsonsig->type)
                       {
                           one2oneParseAndProcess(frame,currSignalStr.toLatin1(),(AlertTypes::EnAlert)AMSignalsModel::getInstance()->jsonGetGraphicItemEnum(jsonsig->action));
                       }
                   }
               }

              //



               //////////////////////////////////////


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
#if 0
    one2oneParseAndProcessGeneral(alertsDisplay, recv, name, alert, polarity);
#else

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
#endif
}

void AwsCanRxMsg::one2oneParseAndProcess(struct can_frame * recv, const char * name, bool * flag, bool polarity)
{
#if 0
    one2oneParseAndProcessGeneral(alertsDisplay, recv, name, alert, polarity);
#else

    bool desired = extractSignal(name,recv).sg_val._bool;

    bool do_active = (desired == polarity);

    if(do_active)
    {
        *flag = true;
    }
    else
    {
        *flag = false;
    }
#endif
}


void AwsCanRxMsg::pedAlertsParseAndProcess(struct can_frame * recv)
{
    switch(extractSignal("PCW_PedDZ",recv).sg_val._int)
    {
    case ped_Clear:
        alertsDisplay->deactivate(AlertTypes::ALERT_PCW);
        alertsDisplay->deactivate(AlertTypes::ALERT_PDZ);
        break;
    case ped_PedDZ:
        alertsDisplay->deactivate(AlertTypes::ALERT_PCW);
        alertsDisplay->activate(AlertTypes::ALERT_PDZ);
        break;

    case ped_PCW:
        alertsDisplay->deactivate(AlertTypes::ALERT_PDZ);
        alertsDisplay->activate(AlertTypes::ALERT_PCW);

    default:
        //skip
        //NOTE: subject for error alert
        break;
    }
}



