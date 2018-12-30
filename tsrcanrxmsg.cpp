#include "defs.h"
#include "canrxmsg.h"
#include "simplecanrxmsg.h"
#include "tsrcanrxmsg.h"

bool TsrCanRxMsg::is_enabled = false;

TsrCanRxMsg::TsrCanRxMsg()
{
    setCanID(can_id_tsr);
    itsJsonProtocol =  AMSignalsModel::getInstance()->getProtocol("Aftermarket_TSR");
    initCanJsonSignalsListInProcessOrder();
}

void TsrCanRxMsg::enable()
{
    is_enabled = true;
}

void TsrCanRxMsg::disable()
{
    TsrCanRxMsg * msg = nullptr;

    msg = (TsrCanRxMsg *)getMsgByCanId(can_id_tsr);

    if(nullptr != msg)
    {
       msg->sliStateParseAndProcess(&(msg->prev_frame), nullptr);
    }
    is_enabled = false;
}



void TsrCanRxMsg::process(struct can_frame * frame)
{
#if 1
    if(is_enabled)
    {

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

                sliStateParseAndProcess(preframe,frame);

               //End of extract fields block

               alertsDisplay->mutex.lock();
               //Activation/Deactivation Block
               qDebug("TSR Can Rx Msg with new info processed @%s:%d", __func__, __LINE__);


               //TODO set simple items

               //End of Activation/Deactivation Block
               alertsDisplay->mutex.unlock();

               memcpy(&prev_frame, frame, sizeof(struct can_frame));
           }
        }




    }
#endif
}

void TsrCanRxMsg::sliStateParseAndProcess(struct can_frame * prev, struct can_frame * recv)
{
    //deactivation:
    bool is_sign_in_prev =  false;
    bool is_sign_in_recv =  false;

    quint8 sign_prev;
    quint8 sign_recv;

    //quint8 supp_prev;
    //quint8 supp_recv;

    size_t i; //pick sign
    size_t j; //filter sign
    size_t k; //find action

    //deactivation:
    if(prev)
    {
        for (i = 0; i < 4; i++)
        {

            is_sign_in_recv = false;
            sign_prev = prev->data[i*2];
            //supp_prev = prev->data[1+i*2];

            //filter:
            if(recv)
            {

                for (j = 0; j < 4; j++)
                {


                    sign_recv = recv->data[j*2];
                    //supp_recv = recv->data[1+j*2];

                    if (sign_prev == sign_recv /*&& supp_prev == supp_recv*/)
                    {
                        is_sign_in_recv = true;
                    }

                }
            }

            if(!is_sign_in_recv)
            {
                //deactivate:
                for (k = 0;k < tsr_alerts_table_size; k++)
                {
                    if(sign_prev == tsr_alerts_table[k].hexcode)
                    {
                        alertsDisplay->deactivate(tsr_alerts_table[k].alert);
                        k = tsr_alerts_table_size;
                    }
                }

            }
        }
    }



    //activation:
    if(recv)
    {
        for (i = 0; i < 4; i++)
        {

            is_sign_in_prev = false;
            sign_recv = recv->data[i*2];
            //supp_recv = recv->data[1+i*2];

            //filter:
            if(prev)
            {
                for (j = 0; j < 4; j++)
                {
                    sign_prev = prev->data[j*2];
                    //supp_prev = prev->data[1+j*2];


                    if (sign_prev == sign_recv /*&& supp_prev == supp_recv*/)
                    {
                        is_sign_in_prev = true;
                    }
                }
            }



            if(!is_sign_in_prev)
            {
                //activate:
                for (k = 0;k < tsr_alerts_table_size; k++)
                {
                    if(sign_recv == tsr_alerts_table[k].hexcode)
                    {
                        alertsDisplay->activate(tsr_alerts_table[k].alert, tsr_alerts_table[k].value);
                        k = tsr_alerts_table_size;
                    }
                }
            }

        }
    }
}


