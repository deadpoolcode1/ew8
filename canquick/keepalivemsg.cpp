#include "watchdogdevice.h"

#include "keepalivemsg.h"
#include "defs.h"

//NOTE: Next header is used for random()
//TODO: replace with QRandomGenerator, when passing to qt 5.12
#include <stdlib.h>

KeepAliveMsg * KeepAliveMsg::instance = nullptr;

KeepAliveMsg::KeepAliveMsg(CanManager * aCanManager): itsCanManager(aCanManager)
{  
    triggerTimerThread = new QThread();
    triggerTimer = new QTimer();



    system_type = stypeInvalid;

    if ("linux" == QSysInfo::kernelType()) {
        QFile deviceModelFile(deviceModelFileName);
        QString modelLine;

        if(deviceModelFile.open(QFile::ReadOnly | QFile::Text))
        {
            modelLine = deviceModelFile.readLine();
            deviceModelFile.close();


            if(modelLine.contains("pcb353"))
            {
                system_type = stypeLinux3_2inch;
            }

            else if(modelLine.contains("pcb000928"))
            {
                system_type = stypeLinux3_5inch;
            }
        }
    }


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
    triggerTimer->setTimerType(Qt::PreciseTimer);

    connect(triggerTimerThread,SIGNAL(started()),triggerTimer,SLOT(start()));
    connect(triggerTimer,SIGNAL(timeout()), this, SLOT(triggerTimeout()));

    this->moveToThread(triggerTimerThread);
    triggerTimer->moveToThread(triggerTimerThread);

    wdt = new WatchDogDevice();

    triggerTimerThread->start();
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
    uint64_t uptime64 = uptimeReference.msecsSinceReference();

    if(Q_UNLIKELY(uptime64 >= std::numeric_limits<uint32_t>::max()))
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

