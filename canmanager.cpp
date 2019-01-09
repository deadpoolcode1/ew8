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

#include <fcntl.h>
#include <errno.h>

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

CanManager::CanManager(IAlertDisplay * alertdisp, QThread * parent) : QThread(parent)
{
    mydisplays = alertdisp;
    init();
    connect(this, SIGNAL(started()),SLOT(process()));
}


void CanManager::init(void)
{
    size_t i = 0;

    iCanRxMsgFactory = new CanRxMsgFactory();

    amSignalsModel = new AMSignalsModel();

    CanRxMsg::initCanRxMsgsPool(iCanRxMsgFactory, mydisplays, amSignalsModel);

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

    qint32 status = 0;

    qint32 flags = fcntl(socknum, F_GETFL);

    if(-1 != flags)
    {
        status = fcntl(socknum, F_SETFL, flags | O_NONBLOCK);
    }
    else
    {

    }

    if(-1 == status)
    {
        qDebug("Unsuccess on NONBLOCKINK CAN socket configure");
    }


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

#if 0
      signalsModel = AMSignalsModel::getInstance();

      signalsModel->jsonGetGraphicItemEnum("ALERT_BLINKERS");

      AMJsonProtocol * amjp = signalsModel->getProtocol("Aftermarket");

      qDebug("JSON: I am protocol and my name is: %s", qPrintable(amjp->getName()));
#endif
}

void CanManager::read_frame(void)
{
#ifndef WIN32
    struct can_frame frame;

    ssize_t nbytes = 0;

    nbytes = read(socknum, &frame, sizeof(struct can_frame));

    if (nbytes < 0) {
         //skip
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
         stat = canReadWait(hnd, &(frame.can_id), (frame.data), &(frame.can_dlc), &flags, &time, 10);
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

void CanManager::write_frame(struct can_frame * frame_ptr)
{
#ifndef WIN32
    ssize_t nbytes = 0;

    nbytes = write(socknum, frame_ptr, sizeof(struct can_frame));

    if (nbytes < 0) {
         qDebug("Can not write to the CAN bus socket!");
    }
#else
    //TODO implement for windows:

      stat = canOK;

      unsigned int flags;

      DWORD time;

      //Waits up to 100 ms for a message
         stat = canReadWait(hnd, &(frame.can_id), (frame.data), &(frame.can_dlc), &flags, &time, 10);
         if (stat == canOK){
           if (flags & canMSG_ERROR_FRAME){
             printf("**Transmitted frame is faulty***");
           }
         }
#endif


}

void CanManager::process()
{

        this->read_frame();
        QTimer::singleShot(0,this,SLOT(process()));
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
            curr->ack(this);
        }

        //TODO move also to the OOP pattern

}
