#include <string.h>
#include <stdio.h>
#include "defs.h"

#include <QDebug>

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
#include <QDateTime>

#include "ialertdisplay.h"
#include "icanrxmsgfactory.h"
#include "canrxmsgfactory.h"
#include "canrxmsg.h"
#include "keepalivemsg.h"
#include "versionmsg.h"
#include "medisconnectionreport.h"

#include "canmanager.h"

#ifndef WIN32
#ifndef VIRTUAL_CAN0
const char * CanManager::can_if_name = "can0";
#else
const char * CanManager::can_if_name = "vcan0";
#endif
#endif

CanManager::CanManager(IAlertDisplay * alertdisp, QObject * parent) : QObject(parent)
{
    itsDisplay = alertdisp;

    init();

    KeepAliveMsg::create(this);


    itsDisconnectionReport = new MeDisconnectionReport(alertdisp);

    CanRxMsg::setItsDisconnectionReport(itsDisconnectionReport);


    itsThread = new QThread(this);

    this->moveToThread(itsThread);

    connect(this, SIGNAL(resetConnectionTimeout()), itsDisconnectionReport, SLOT(resetConnectionTimeout()));

    connect(itsThread,SIGNAL(started()),this,SLOT(process()));
}

void CanManager::launch(void)
{
    VersionMsg::create(this);
    VersionMsg::singleShot();
    itsDisconnectionReport->launch();
    itsThread->start();

}

//TODO: unite volume functions
void CanManager::sendVolumeDown(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x0)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);


    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendVolumeUp(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x1)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}


void CanManager::sendVolumeGet(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x2)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendVolumeMute(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x3)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAFullDeact()
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x5)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAPartDeact(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x4)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAFullActivate(void)
{
    quint16 requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (quint8)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (quint8)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x6)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
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

    can_err_status = can_do_stop(can_if_name);

    if(can_err_status)
    {
        qDebug("failed can interface stop");
    }
    else
    {
        //set parameters:
        can_err_status = can_set_bitrate_samplepoint(can_if_name, 500000, 0.875);

        struct can_ctrlmode cm =
        {
            .mask = 0x00,
            .flags = 0x80, // CAN_CTRLMODE_FD_NON_ISO,
        };

        can_err_status |= can_set_ctrlmode(can_if_name, &cm);


        if(can_err_status)
        {
            qDebug("can parameters configuration failed");
        }
        else
        {
            can_err_status = can_do_start(can_if_name);

            if(can_err_status)
            {
                qDebug("failed can interface start");
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

    struct can_filter rfilter [rfilterSize];

    for (size_t i = 0; i < rfilterSize; i++)
    {
           rfilter[i].can_id = rfilterList.at(i);
           rfilter[i].can_mask = CAN_SFF_MASK;
    }

    socknum = socket(PF_CAN, SOCK_RAW, CAN_RAW);

#if 0
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
#endif


    setsockopt(socknum, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, rfilterSize * sizeof(struct can_filter));

    strcpy(ifr.ifr_name, can_if_name);
    ioctl(socknum, SIOCGIFINDEX, &ifr);

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    bind(socknum, (struct sockaddr *)&addr, sizeof(addr));
    qDebug("can interface initiated");
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

#if 0
    bool isKnownFrameReceived = false;
#endif

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
#if 1
        qDebug() << "can interface:" << (void*) (quint32) frame.can_id << ":" <<
                   (void*) (quint32) frame.data[0] <<
                   (void*) (quint32) frame.data[1] <<
                   (void*) (quint32) frame.data[2] <<
                   (void*) (quint32) frame.data[3] <<
                   (void*) (quint32) frame.data[4] <<
                   (void*) (quint32) frame.data[5] <<
                   (void*) (quint32) frame.data[6] <<
                   (void*) (quint32) frame.data[7] <<
                   "ts:" << QDateTime::currentMSecsSinceEpoch();
#endif

#if 0
            isKnownFrameReceived =
#endif
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
#if 0
            isKnownFrameReceived =
#endif
            parse_frame(&frame);
           }
         }
         //Break the loop if something goes wrong
         else if (stat != canERR_NOMSG){

         }


#endif


//NOTE: For disconnection timer reset keepAlive msg only used
#if 0
         if(isKnownFrameReceived)
         {
           emit resetConnectionTimeout();
         }
#endif
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
      stat = canOK;
      unsigned int flags = canMSG_STD;

      stat = canWriteWait(hnd, (frame_ptr->can_id), (frame_ptr->data), (frame_ptr->can_dlc), flags, 10);
      if (stat != canOK){
          if (stat & canMSG_ERROR_FRAME){
              printf("**Transmitted frame is faulty***");
          }
      }
#endif
}

void CanManager::process()
{
while(true)
{
    this->read_frame();
}
#if 0
    QTimer::singleShot(0,this,SLOT(process()));
#endif
}

bool CanManager::parse_frame(struct can_frame * frame)
{
    bool status = false;

          if(CanRxMsg::isKeepAliveMsg(frame->can_id))
          {
             emit resetConnectionTimeout();
          }

          CanRxMsg * curr = CanRxMsg::getMsgByCanId(frame->can_id);

          if(nullptr != curr)
          {


              status = true;
              curr->process(frame);
              curr->ack(this);
              itsDisplay->forceUpdate();
#if 0
              qDebug() << "message" << (void*)(quint32) frame->can_id <<"processed ts:" << QDateTime::currentMSecsSinceEpoch();
#endif
          }

        return status;
}
