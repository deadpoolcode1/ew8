#include "canmanager.h"
#include <string.h>
#include <stdio.h>
#include "defs.h"

#ifndef WIN32
#include <unistd.h>
#include <can_netlink.h>
#include <libsocketcan.h>

#include <net/if.h>
#include <linux/types.h>

#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/uio.h>

#include <linux/can.h>
#include <linux/can/raw.h>

#else

#include "canlib.h"

#endif


#include <QThread>
#include <QMutex>
#include <QTimer>

#include "ialertdisplay.h"
#include "icanrxmsgfactory.h"
#include "canrxmsgfactory.h"
#include "canrxmsg.h"

CanManager::CanManager(IAlertDisplay * alertdisp)
{
    mydisplays = alertdisp;
    init();
    connect(this, SIGNAL(started()),SLOT(process()));
}


void CanManager::init(void)
{
    size_t i = 0;

    iCanRxMsgFactory = new CanRxMsgFactory();

    CanRxMsg::initCanRxMsgsPool(iCanRxMsgFactory, mydisplays);

    is_tsr_enabled = false;

    for(i = 0; i < CAN_MESSAGES_TYPES_NUM;i++)
    {
        init_frame(&(prev_frame[i]));
        is_a_first_frame[i] =  true;
    }

#ifndef WIN32

    //CAN interface configuration:

    int can_err_status;


    can_err_status = can_do_stop("can0");

    if(can_err_status)
    {
        printf("failed can0 stop\n");
    }
    else
    {
        //set parameters:
#if 1
        can_err_status = can_set_bitrate_samplepoint("can0", 500000, 0.875);
#else
        can_err_status = can_set_bitrate("can0", 500000);
        can_err_status |= can_set_bittiming(const char *name, struct can_bittiming *bt);
#endif

        struct can_ctrlmode cm =
        {
            .mask = 0x00,
            .flags = 0x80, // CAN_CTRLMODE_FD_NON_ISO,
        };

#if 0
        can_get_ctrlmode("can0",&cm);
        printf("cm.mask:%X,cm.flag:%X\n",cm.mask,cm.flags);
#endif

        can_err_status |= can_set_ctrlmode("can0", &cm);


        if(can_err_status)
        {
            printf("can parameters configuration failed\n");
        }
        else
        {
            can_err_status = can_do_start("can0");

            if(can_err_status)
            {
                printf("failed can0 start\n");
            }
        }
    }

    if(!can_err_status)
    {
      printf("Can interface configuration succeed\n");
    }



    //CAN Socket configuration:
    for (i = 0; i < CAN_MESSAGES_TYPES_NUM; i++)
    {
        rfilter[i].can_id = can_id_values_table[i].value;
        rfilter[i].can_mask = CAN_SFF_MASK;
    }

    socknum = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    setsockopt(socknum, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, sizeof(rfilter));

    strcpy(ifr.ifr_name, "can0" );
    ioctl(socknum, SIOCGIFINDEX, &ifr);

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    bind(socknum, (struct sockaddr *)&addr, sizeof(addr));
    qDebug("can0 initiated");
#else
      canInitializeLibrary();

      //Channel initialization
      hnd = canOpenChannel(0, canOPEN_ACCEPT_VIRTUAL);

      //canSetBusOutputControl(hnd, canDRIVER_NORMAL);


      stat = canSetBusParams(hnd, canBITRATE_500K, 0, 0, 0, 0, 0);
      stat = canBusOn(hnd);

      //TODO add filter,sampling point and normal mode

#endif
}

void CanManager::read_frame(void)
{
#ifndef WIN32
    struct can_frame frame;

    ssize_t nbytes = 0;

    nbytes = read(socknum, &frame, sizeof(struct can_frame));

    if (nbytes < 0) {
        fprintf(stderr,"CAN raw socket read");
    }
    else if (nbytes < (ssize_t)sizeof(struct can_frame))
    {
        fprintf(stderr, "read: incomplete CAN frame\n");
    }
    else
    {
        parse_frame(&frame);
    }

#else
      stat = canOK;

      struct can_frame frame;

      unsigned int flags;

      /*
      long id;
      unsigned int dlc, flags;
      unsigned char data[8];
      */
      DWORD time;

      //Waits up to 100 ms for a message
         stat = canReadWait(hnd, &(frame.can_id), (frame.data), &(frame.can_dlc), &flags, &time, 100);
         if (stat == canOK){
           if (flags & canMSG_ERROR_FRAME){
             printf("***ERROR FRAME RECEIVED***");
           }
           else {
             parse_frame(&frame);
           }
         }
         //Break the loop if something goes wrong
         else if (stat != canERR_NOMSG){

         }


#endif
}



void CanManager::init_frame(struct can_frame * frame)
{
      frame->can_id =  0x0;
      frame->can_dlc = 0x0;
      frame->__pad =   0x0;
      frame->__res0 =  0x0;
      frame->__res1 =  0x0;
      frame->data[0] = 0x0;
      frame->data[1] = 0x0;
      frame->data[2] = 0x0;
      frame->data[3] = 0x0;
      frame->data[4] = 0x0;
      frame->data[5] = 0x0;
      frame->data[6] = 0x0;
      frame->data[7] = 0x0;
}

void CanManager::write_frame(void)
{


}

void CanManager::process()
{

        this->read_frame();
        QTimer::singleShot(0,this,SLOT(process()));
}

void CanManager::sliStateParseAndProcess(struct can_frame * prev, struct can_frame * recv)
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
                        mydisplays->deactivate(tsr_alerts_table[k].alert);
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
                        mydisplays->activate(tsr_alerts_table[k].alert, tsr_alerts_table[k].value);
                        k = tsr_alerts_table_size;
                    }
                }
            }

        }
    }
}

void CanManager::parse_frame(struct can_frame * frame)
{
    can_id_t received_id = can_id_undefined;

        for (size_t i = 0; i < CAN_MESSAGES_TYPES_NUM; i++)
        {
             if(can_id_values_table[i].value == frame->can_id)
             {
                 received_id = can_id_values_table[i].mnemonic;

                 i = CAN_MESSAGES_TYPES_NUM;
             }
        }


        CanRxMsg * curr = CanRxMsg::getMsgByCanId(received_id);

        if(nullptr != curr)
        {
            curr->process(frame);
        }

        //TODO move also to the OOP pattern
        parse_frame1(frame);

}

void CanManager::parse_frame1(struct can_frame * frame)
{
    can_id_t received_id = can_id_undefined;
    bool is_frame_updated = false;

    for (size_t i = 0; i < CAN_MESSAGES_TYPES_NUM; i++)
    {
         if(can_id_values_table[i].value == frame->can_id)
         {
             received_id = can_id_values_table[i].mnemonic;
             
             i = CAN_MESSAGES_TYPES_NUM;
         }
    }

    //filter enabled/disabled messages (only can_id_tsr currently):
    if(can_id_tsr == received_id && !is_tsr_enabled)
    {
        //TODO add array of enabled/disabled messages
        //TODO make return point of the function single.
        return;
    }




    //WARNING the first received frame is "preceeded" by a NULL frame
    struct can_frame * preframe = nullptr;

    if (is_a_first_frame[received_id])
    {
        is_a_first_frame[received_id] = false;
    }
    else
    {
        preframe = &prev_frame[received_id];
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

    //display information:


   if(!is_frame_updated)
   {
       //skip
   }
   else
   {    

        mydisplays->mutex.lock();

        switch(received_id)
        {
               case can_id_master:
               //moved to Strategy pattern
           break;

        case can_id_tsr:

                sliStateParseAndProcess(preframe,frame);

            break;

        case can_id_s_adas:

            break;

        case can_id_undefined:
            //never used
            break;
        }
        mydisplays->mutex.unlock();

        memcpy(&prev_frame[received_id], frame, sizeof(struct can_frame));
   }

}
