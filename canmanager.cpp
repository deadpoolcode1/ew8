#include "canmanager.h"
#include <string.h>
#include <stdio.h>
#include "defs.h"

#include "candbsignal.h"

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

CanManager::CanManager(IAlertDisplay * alertdisp, QObject * parent) : QObject(parent)
{
    itsDisplay = alertdisp;

    init();

    isInDisconnectionAlert = false;

    timeoutTimer = new QTimer(this);
    timeoutTimer->setSingleShot(true);
    timeoutTimer->setInterval(DEFAULT_EW_CAN_CONNECTION_TIMEOUT);

    connect(timeoutTimer,SIGNAL(timeout()), this, SLOT(fireConnectionTimeout()));

    itsThread = new QThread(this);

    this->moveToThread(itsThread);

    connect(itsThread,SIGNAL(started()),this,SLOT(process()));
}

void CanManager::launch(void)
{
    itsThread->start();
}

void CanManager::setConnectionTimeoutMsec(quint32 aTimeout)
{
    if(timeoutTimer->isActive())
    {
        qDebug("Setting new connection timeout resets timeout timer");
        timeoutTimer->stop();
        timeoutTimer->setInterval(aTimeout);
        timeoutTimer->start();
    }
    else
    {
        timeoutTimer->setInterval(aTimeout);
    }

}

void CanManager::fireConnectionTimeout()
{
    qDebug("Disconnection Alert!");
    isInDisconnectionAlert = true;
    itsDisplay->activate(AlertTypes::ALERT_NOCOM);
}

void CanManager::resetConnectionTimeout(void)
{
    if(timeoutTimer->isActive())
    {
        qDebug("CAN timeout timer stopped!");
        timeoutTimer->stop();
    }

    if(isInDisconnectionAlert)
    {
        qDebug("CAN interface reconnected.");
        itsDisplay->deactivate(AlertTypes::ALERT_NOCOM);
        isInDisconnectionAlert = false;
    }

}

 IAlertDisplay * CanManager::getItsDisplay(void)
 {
    return itsDisplay;
 }

 ICanRxMsgFactory * CanManager::getItsCanRxMsgFactory(void)
 {
     return itsCanRxMsgFactory;
 }


void CanManager::init(void)
{
    itsCanRxMsgFactory = new CanRxMsgFactory();

    amSignalsModel = new AMSignalsModel(this);

    CanRxMsg::completeInitCanRxMsgsPool();



#ifndef WIN32

    //CAN interface configuration:

    int can_err_status;


    can_err_status = can_do_stop("can0");

    if(can_err_status)
    {
        qDebug("failed can0 stop");
    }
    else
    {
        //set parameters:
        can_err_status = can_set_bitrate_samplepoint("can0", 500000, 0.875);

        struct can_ctrlmode cm =
        {
            .mask = 0x00,
            .flags = 0x80, // CAN_CTRLMODE_FD_NON_ISO,
        };

#if 0
        can_get_ctrlmode("can0",&cm);
        qDebug("cm.mask:%X,cm.flag:%X\n",cm.mask,cm.flags);
#endif

        can_err_status |= can_set_ctrlmode("can0", &cm);


        if(can_err_status)
        {
            qDebug("can parameters configuration failed");
        }
        else
        {
            can_err_status = can_do_start("can0");

            if(can_err_status)
            {
                qDebug("failed can0 start");
            }
        }
    }

    if(!can_err_status)
    {
      qDebug("Can interface configuration succeed\n");
    }



    //CAN Socket configuration:

    const QList<CanStdId_t> rfilterList = CanRxMsg::getMsgsWhiteList();

    size_t rfilterSize = rfilterList.size();

    rfilter = new struct can_filter[rfilterSize];

    for (size_t i = 0; i < rfilterSize; i++)
    {
           rfilter[i].can_id = rfilterList.at(i);
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


    setsockopt(socknum, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, rfilterList.size());

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

    bool isKnownFrameReceived = false;


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
        isKnownFrameReceived = parse_frame(&frame);
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
             isKnownFrameReceived = parse_frame(&frame);
           }
         }
         //Break the loop if something goes wrong
         else if (stat != canERR_NOMSG){

         }


#endif

#if 0
         //NOTE: Starting timeout timer on error -- wrong behaviour
         if(isKnownFrameReceived)
         {
             if(timeoutTimer->isActive())
             {
                 qDebug("CAN timeout timer stopped!");
                 timeoutTimer->stop();
             }

             if(isInDisconnectionAlert)
             {
                 qDebug("CAN interface reconnected.");
                 itsDisplay->deactivate(AlertTypes::ALERT_NOCOM);
                 isInDisconnectionAlert = false;
             }
         }
         else if ((!isInDisconnectionAlert)&&(!isKnownFrameReceived)&&(!timeoutTimer->isActive()))
         {
             qDebug("CAN timeout timer started!");
             timeoutTimer->start();
         }
#else
         //NOTE: Starting timeout timer on frame received -- right behaviour
         if(isKnownFrameReceived)
         {
           resetConnectionTimeout();
         }

         if((!isInDisconnectionAlert)&&!(timeoutTimer->isActive()))
         {
             qDebug("CAN timeout timer stopped!");
             timeoutTimer->start();
         }
#endif
}



void CanManager::init_frame(struct can_frame * frame)
{
      frame->can_id =  0x0;
      frame->can_dlc = 0x0;
#ifndef WIN32
      frame->__pad =   0x0;
      frame->__res0 =  0x0;
      frame->__res1 =  0x0;
#endif
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
         stat = canReadWait(hnd, &(frame_ptr->can_id), (frame_ptr->data), &(frame_ptr->can_dlc), &flags, &time, 10);
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

bool CanManager::parse_frame(struct can_frame * frame)
{
    bool status = false;

        CanRxMsg * curr = CanRxMsg::getMsgByCanId(frame->can_id);

        if(nullptr != curr)
        {
            status = true;
            curr->process(frame);
            curr->ack(this);
        }

        return status;
}
