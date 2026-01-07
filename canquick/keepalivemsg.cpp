#include "watchdogdevice.h"

#include "keepalivemsg.h"
#include "defs.h"
#include "core/file_utils.h"

//NOTE: Next header is used for random()
#include <stdlib.h>
#include <limits>

KeepAliveMsg * KeepAliveMsg::instance = nullptr;

KeepAliveMsg::KeepAliveMsg(CanManager * aCanManager): itsCanManager(aCanManager)
{
    triggerTimerThread = new core::Thread();
    triggerTimer = new core::Timer();

    system_type = stypeInvalid;

#ifdef __linux__
    {
        core::File deviceModelFile(deviceModelFileName);
        std::string modelLine;

        if(deviceModelFile.open(core::File::ReadOnly | core::File::Text))
        {
            modelLine = deviceModelFile.readLine();
            deviceModelFile.close();


            if(modelLine.find("pcb353") != std::string::npos)
            {
                system_type = stypeLinux3_2inch;
            }

            else if(modelLine.find("pcb000928") != std::string::npos)
            {
                system_type = stypeLinux3_5inch;
            }
        }
    }
#endif

    sessionId = rand()%0xffff;
    errorId = 0x00;
    isValid = true;

    frame_to_send.can_id = 0x7e0;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[4] = (uint8_t)((sessionId >> 000) & 0xff);;
    frame_to_send.data[5] = (uint8_t)((sessionId >> 010) & 0xff);
    frame_to_send.data[6] = (system_type << 4);//TODO add Operational Mode

    triggerTimer->setSingleShot(false);
    triggerTimer->setInterval(DEFAULT_EW_KEEP_ALIVE_TIMEOUT);

    // Connect timer timeout to triggerTimeout using core::Signal
    triggerTimer->timeout.connect([this]() {
        triggerTimeout();
    });

    wdt = new WatchDogDevice();

    // Start the timer (it runs in its own thread internally)
    triggerTimer->start();
}

KeepAliveMsg::~KeepAliveMsg()
{
    if (triggerTimer) {
        triggerTimer->stop();
        delete triggerTimer;
    }
    if (triggerTimerThread) {
        triggerTimerThread->quit();
        triggerTimerThread->wait();
        delete triggerTimerThread;
    }
    delete wdt;
}

void KeepAliveMsg::create(CanManager *aCanManager)
{
    if(instance == nullptr)
    {
        instance = new KeepAliveMsg(aCanManager);
    }
}

void KeepAliveMsg::triggerTimeout(void)
{
    //NOTE: fetch uptime at a moment close to send
    uptimeReference.start();
    uint64_t uptime64 = static_cast<uint64_t>(core::ElapsedTimer::currentMSecsSinceEpoch());

    if(uptime64 >= std::numeric_limits<uint32_t>::max())
    {
        frame_to_send.data[0] = 0xff;
        frame_to_send.data[1] = 0xff;
        frame_to_send.data[2] = 0xff;
        frame_to_send.data[3] = 0xff;
    }
    else
    {
        frame_to_send.data[0] = (uint8_t)((uptime64 >> 000) & 0xff);
        frame_to_send.data[1] = (uint8_t)((uptime64 >> 010) & 0xff);
        frame_to_send.data[2] = (uint8_t)((uptime64 >> 020) & 0xff);
        frame_to_send.data[3] = (uint8_t)((uptime64 >> 030) & 0xff);
    }

    frame_to_send.data[7] = (isValid? (uint8_t)(0x80 | errorId) : (uint8_t)(0x7f & errorId));

    wdt->toggle();

    itsCanManager->write_frame(&frame_to_send);
}
