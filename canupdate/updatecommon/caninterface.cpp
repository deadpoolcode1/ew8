
#include "updatecanprotocol.h"
#include "utils.h"

#include "caninterface.h"
#include <string.h>
#include <stdio.h>
#include <pthread.h>

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

#include <time.h>

#else

#include "canlib.h"

#endif

CANInterface::CANInterface(int _can_id, int _can_mask)
{
    m_drop = false;
    Init(_can_id, _can_mask);
    // update with callback
}

CANInterface::~CANInterface()
{

}

void CANInterface::SleepWhileActive()
{
    void* status;

    pthread_join(m_PollThread, &status);

    m_active = false;
}

void CANInterface::Init(int _can_id, int _can_range)
{
    int _can_mask = 0xffff;
    int can_count = 0;
    while(_can_range > 0)
    {
        _can_range >>= 1;
        can_count ++;
    }
    _can_mask <<= (can_count-1);

#ifndef WIN32
#ifdef CAN_RECONFIGURE

    //CAN interface configuration:

    int can_err_status;

    can_err_status = can_do_stop("can0");

    if(can_err_status)
    {
        LOG("failed can0 stop");
    }
    else
    {
        //set parameters:
#if 1
        const float sample_point = 0.875;
        can_err_status = can_set_bitrate_samplepoint("can0", 500000, sample_point);
#else
        can_err_status = can_set_bitrate("can0", 500000);
        can_err_status |= can_set_bittiming(const char *name, struct can_bittiming *bt);
#endif

        if(can_err_status)
        {
            LOG("can parameters configuration failed");
        }
        else
        {
            can_err_status = can_do_start("can0");

            if(can_err_status)
            {
                LOG("failed can0 start");
            }
        }
    }

    if(!can_err_status)
    {
      LOG("Can interface configuration succeed\n");
    }
#endif

    socknum = socket(PF_CAN, SOCK_RAW, CAN_RAW);

    int32_t status = 0;

    int32_t flags = fcntl(socknum, F_GETFL);

    int non_blocking = 0;

    if (non_blocking) { // blocking configuration
        if(-1 != flags)
        {
            status = fcntl(socknum, F_SETFL, flags | O_NONBLOCK);
        }
        else
        {
        }
    }

    if(-1 == status)
    {
        LOG("Unsuccess on NONBLOCKINK CAN socket configure");
    }

    // can filter
    const int filter_rules = 1;
    can_filter rfilter;
    rfilter.can_id = _can_id;
    rfilter.can_mask = _can_mask;

    setsockopt(socknum, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, sizeof(can_filter)*filter_rules);

    strcpy(ifr.ifr_name, "can0" );
    ioctl(socknum, SIOCGIFINDEX, &ifr);

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    bind(socknum, (struct sockaddr *)&addr, sizeof(addr));
    LOG("can0 initiated");


#else

      int channel = 0;

      canInitializeLibrary();

      //Channel initialization
      hnd = canOpenChannel(channel, canOPEN_ACCEPT_VIRTUAL);

      //canSetBusOutputControl(hnd, canDRIVER_NORMAL);

      stat = canSetBusParams(hnd, canBITRATE_500K, 0, 0, 0, 0, 0);
      stat = canBusOn(hnd);
      //TODO add filter,sampling point and normal mode

      stat = canSetAcceptanceFilter(hnd, _can_id, _can_mask, false);

#endif
    m_active = true;
    m_ReadObj = NULL;

    int result = pthread_create(&m_PollThread, NULL, IntThread, this);

    if (0 != result)
    {   m_active = false;   }

}

void* CANInterface::IntThread(void * _param)
{
    CANInterface* ci = (CANInterface*)_param;

    can_frame frame;

    while(ci->m_active)
    {
        if (0 == ci->ReadFrame(&frame))
        {
            if (ci->m_ReadObj)
            {
                ci->m_ReadObj->CANPacketReceptor(&(frame.data[0]), (uint32_t)frame.can_dlc);
            }
        }
    }

    pthread_exit(0);
    return NULL;
}

int CANInterface::ReadFrame(can_frame* frame)
{
#ifndef WIN32

    ssize_t nbytes = 0;

    nbytes = read(socknum, frame, sizeof(struct can_frame));

    if (nbytes < 0) {
         //skip
        // usleep(50000);

        return -1;
    }
    else if (nbytes < (ssize_t)sizeof(struct can_frame))
    {
        LOG("read: incomplete CAN frame\n");
        return -1;
    }
    else
    {
        return 0;
    }

#else
      stat = canOK;

      unsigned int flags;

      DWORD time;

      //Waits up to 100 ms for a message
         stat = canReadWait(hnd, &(frame->can_id), (frame->data), &(frame->can_dlc), &flags, &time, 10);
         if (stat == canOK){
           if (flags & canMSG_ERROR_FRAME){
             LOG("***ERROR FRAME RECEIVED***");
             return -1;
           }
           else
           { return 0; }
         }
         if (canERR_NOMSG == stat)
         {
             if (0) LOG("Reading CAN msg - no message\n");
             return -1;
         }
#endif
     return 0;
}

#ifdef DROP_DEBUG
void CANInterface::DropStat()
{
    if (DDCANPacketType == CANProtocol::CAN_SEND_DATA)
    {
       LOG("Dropped CAN packet #%d of %d from Data packet\n", DDCANSequenceNumber, (DDCANPacketLen+7)/8);
    }
    else
    {
        if (DDCANPacketType >= (unsigned char)CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK)
        {
            LOG("Dropped CAN packet #%d of %d from Acknowledge packet\n", DDCANSequenceNumber, (DDCANPacketLen+7)/8);
        }
        else
        {
            LOG("Dropped CAN packet #%d of %d from Command packet\n", DDCANSequenceNumber, (DDCANPacketLen+7)/8);
        }
    }
}
#endif

void CANInterface::WriteFrame(struct can_frame * frame_ptr)
{

    if (m_drop)
    {
        if (rand()%DROP_RATIO == 0)
        {
#ifdef DROP_DEBUG
            DropStat();
#endif
           return;
        }
    }

#ifndef WIN32
    ssize_t nbytes = 0;

    nbytes = write(socknum, frame_ptr, sizeof(struct can_frame));

    if (nbytes < 0) {
         LOG("Can not write to the CAN bus socket!");
    }
#else
    //TODO implement for windows:

      stat = canOK;
      unsigned m_flag;
      m_flag = 0 | canMSG_STD;

      // frame_ptr->can_id =
      stat = canWrite(hnd, frame_ptr->can_id, frame_ptr->data, frame_ptr->can_dlc, m_flag);
      if (canERR_TXBUFOFL == stat)
      {
          unsigned counter = 0;
          do {
              stat = canWrite(hnd, frame_ptr->can_id, frame_ptr->data, frame_ptr->can_dlc, m_flag);
              counter++;
              usleep(200);
              if (counter > TOO_MANY_RETRIES)
              {
                  return;
              }
          }
          while (stat == canERR_TXBUFOFL);
      }

      if (canOK != stat)
      {
          LOG("CAN send with error\n");
      }
#endif
}

void CANInterface::WriteFrameLowerPri(struct can_frame * frame_ptr)
{
    if (m_drop)
    {
        if (rand()%DROP_RATIO == 0)
        {
#ifdef DROP_DEBUG
            DropStat();
#endif
           return;
        }
    }

#ifndef WIN32
    ssize_t nbytes = 0;

    nbytes = write(socknum, frame_ptr, sizeof(struct can_frame));

    if (nbytes < 0) {
         LOG("Can not write to the CAN bus socket!");
    }
#else
    //TODO implement for windows:

      stat = canOK;
      unsigned m_flag;
      m_flag = 0 | canMSG_STD;

      // frame_ptr->can_id =
      stat = canWrite(hnd, frame_ptr->can_id, frame_ptr->data, frame_ptr->can_dlc, m_flag);
      if (canERR_TXBUFOFL == stat)
      {
          unsigned counter = 0;
          do {
              stat = canWrite(hnd, frame_ptr->can_id, frame_ptr->data, frame_ptr->can_dlc, m_flag);
              counter++;
              usleep(200);
              if (counter > TOO_MANY_RETRIES)
              {
                  return;
              }
          }
          while (stat == canERR_TXBUFOFL);
      }
      // canWriteSync(hnd, 500);

      if (canOK != stat)
      {
          LOG("CAN send with error\n");
      }
#endif
}




