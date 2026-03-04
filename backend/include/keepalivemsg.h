#ifndef KEEPALIVEMSG_H
#define KEEPALIVEMSG_H

#include "canmanager.h"
#include "core/thread.h"
#include "core/timer.h"
#include "core/elapsed_timer.h"

class CanManager;
class WatchDogDevice;

class KeepAliveMsg
{
    enum system_type_e: uint8_t
    {
        stypeLinux3_2inch = 0x0
        ,stypeAndroid = 0x1
        ,stypeBareMetal = 0x2
        ,stypeLinux3_5inch = 0x3

        ,stypeInvalid = 0xf,
    };

public:
    static void create(CanManager * aCanManager);
    ~KeepAliveMsg();

    void triggerTimeout(void);

private:
    CanManager * itsCanManager;
    explicit KeepAliveMsg(CanManager * aCanManager);
    core::Thread* triggerTimerThread;
    core::Timer* triggerTimer;
    static KeepAliveMsg * instance;
    core::ElapsedTimer uptimeReference;
    uint16_t sessionId;
    system_type_e system_type;
    struct can_frame frame_to_send;
    bool isValid;
    uint8_t errorId;

    WatchDogDevice * wdt;

    const String deviceModelFileName = "/sys/firmware/devicetree/base/model";

};

#endif // KEEPALIVEMSG_H
