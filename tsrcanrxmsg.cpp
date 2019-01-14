#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "tsrcanrxmsg.h"


TsrCanRxMsg::TsrCanRxMsg()
{
    setCanID(can_id_tsr);
}

void TsrCanRxMsg::process(struct can_frame * frame)
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

       canRxJsonSignalsParseAndProcess(frame);

       //End of extract fields block

       qDebug("AWS Can Rx Msg with new info processed @%s:%d", __func__, __LINE__);

       memcpy(&prev_frame, frame, sizeof(struct can_frame));
   }
}




