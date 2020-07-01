#include "keepalivemsg.h"
#include "defs.h"
#include <QDebug>

//NOTE: Next header is used for random()
//TODO: replace with QRandomGenerator, when passing to qt 5.12
#include <stdlib.h>

KeepAliveMsg * KeepAliveMsg::instance = nullptr;

KeepAliveMsg::KeepAliveMsg(CanManager * aCanManager): itsCanManager(aCanManager)
{  
    triggerTimerThread = new QThread();
    triggerTimer = new QTimer();



    system_type = stypeInvalid;
    if ("linux" == QSysInfo::kernelType()) {system_type = stypeLinux;}

    sessionId = rand()%0xffff;
    errorId = 0x00;
    isValid = true;

    frame_to_send.can_id = 0x7e0;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[4] = (quint8)((sessionId >> 000) & 0xff);;
    frame_to_send.data[5] = (quint8)((sessionId >> 010) & 0xff);
    frame_to_send.data[6] = (system_type << 4);//TODO add Operational Mode

    triggerTimer->setSingleShot(false);
    triggerTimer->setInterval(DEFAULT_EW_KEEP_ALIVE_TIMEOUT);
    triggerTimer->setTimerType(Qt::PreciseTimer);

    connect(triggerTimerThread,SIGNAL(started()),triggerTimer,SLOT(start()));
    connect(triggerTimer,SIGNAL(timeout()), this, SLOT(triggerTimeout()));

    triggerTimer->moveToThread(triggerTimerThread);
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
    quint64 uptime64 = uptimeReference.msecsSinceReference();

    if(Q_UNLIKELY(uptime64 >= std::numeric_limits<quint32>::max()))
    {
        frame_to_send.data[0] = 0xff;
        frame_to_send.data[1] = 0xff;
        frame_to_send.data[2] = 0xff;
        frame_to_send.data[3] = 0xff;
    }
    else
    {
        frame_to_send.data[0] = (quint8)((uptime64 >> 000) & 0xff);
        frame_to_send.data[1] = (quint8)((uptime64 >> 010) & 0xff);
        frame_to_send.data[2] = (quint8)((uptime64 >> 020) & 0xff);
        frame_to_send.data[3] = (quint8)((uptime64 >> 030) & 0xff);
    }

    frame_to_send.data[7] = (isValid? (quint8)(0x80 | errorId) : (quint8)(0x7f & errorId));

    itsCanManager->write_frame(&frame_to_send);
}

