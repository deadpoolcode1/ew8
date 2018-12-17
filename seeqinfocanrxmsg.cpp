#include "seeqinfocanrxmsg.h"
#include "defs.h"

#include "canrxmsg.h"
#include "simplecanrxmsg.h"

#include "amsignalsmodel.h"
#include "amjsonprotocol.h"
#include "candbsignal.h"

#include "qquickqrcode.h"

SeeQInfoCanRxMsg::SeeQInfoCanRxMsg()
{
  setCanID(can_id_cq_info);
  itsJsonProtocol =  AMSignalsModel::getInstance()->getProtocol("SeeQInfo");
}

void SeeQInfoCanRxMsg::process(struct can_frame * frame)
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


       //NOTE: this time is displayed, when differs from zero

        quint8 num0 = extractSignal("SeeQSerialNumber0",frame).sg_val._int;
        quint8 num1 = extractSignal("SeeQSerialNumber1",frame).sg_val._int;
        quint8 num2 = extractSignal("SeeQSerialNumber2",frame).sg_val._int;
        quint8 num3 = extractSignal("SeeQSerialNumber3",frame).sg_val._int;
        quint8 num4 = extractSignal("SeeQSerialNumber4",frame).sg_val._int;

        alertsDisplay->deactivate(AlertTypes::ALERT_QRCODE);

        if(num0 | num1 | num2 | num3 |num4)
        {
            qDebug("QRCode Dispaly Activation");


              QQuickQRCode::setSn(
                 QString::number(num0)
               + QString::number(num1)
               + QString::number(num2)
               + QString::number(num3)
               + QString::number(num4)
                );
            alertsDisplay->activate(AlertTypes::ALERT_QRCODE);
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

