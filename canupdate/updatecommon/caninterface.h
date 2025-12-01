#ifndef CANMANAGER_H
#define CANMANAGER_H

// #define DROP_TEST

#ifndef WIN32
#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>
#else
#include "canlib.h"
#endif

#include <stdint.h>
#include <unistd.h>

#include "canreceptor.h"

#define DROP_DEBUG

#ifdef WIN32


struct can_frame{
      long can_id; 
      uint32_t    can_dlc;
      uint8_t    data[8];
};

#endif

#ifdef DROP_DEBUG
extern unsigned char DDCANPacketType;
extern unsigned char DDCANSequenceNumber;
extern unsigned int  DDCANPacketLen;
#endif

const unsigned int TOO_MANY_RETRIES = 200;

#include <pthread.h>

class CANInterface
{
public:
    CANReceptor* m_ReadObj;

    pthread_t m_PollThread;
    bool m_active;
    bool m_drop;

#ifdef WIN32
    int const DROP_RATIO = 1000; // 1 drop per 1000 packets
#else
    int const DROP_RATIO = 100; // 1 drop per 100 packets
#endif

    CANInterface(int _can_id, int _can_mask);
    int ReadFrame(can_frame* frame);
    void WriteFrame(struct can_frame * frame_ptr);
    void WriteFrameLowerPri(struct can_frame * frame_ptr);
    void SetDropTest(bool _drop)
    {
        m_drop = _drop;
    }
#ifdef DROP_DEBUG
    void DropStat();
#endif

    void SetFrameProcessor(CANReceptor* _cr)
    {
        m_ReadObj = _cr;
    }
    bool isActive()
    {
        return m_active;
    }
    void SleepWhileActive();

    static void* IntThread(void*);

    ~CANInterface();

private:
    //inner functions:
    void Init(int _can_id, int _can_mask);

#ifndef WIN32
    //inner variables
    int32_t socknum;
    struct sockaddr_can addr;
    struct ifreq ifr;
    struct can_filter * rfilter;
#else
    canHandle  hnd;
    canStatus  stat;
#endif

};


#endif // CANMANAGER_H
