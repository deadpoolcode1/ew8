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
    setCanID(can_id_master);
    itsJsonProtocol =  AMSignalsModel::getInstance()->getProtocol("Aftermarket");
    initCanJsonSignalsListInProcessOrder();
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

#if 0
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
#endif


       canRxJsonSignalsParseAndProcess(frame);

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


