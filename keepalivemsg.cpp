#include "keepalivemsg.h"
#include "defs.h"

KeepAliveMsg * KeepAliveMsg::instance = nullptr;

KeepAliveMsg::KeepAliveMsg(CanManager * aCanManager): itsCanManager(aCanManager)
{
    triggerTimer = new QTimer(aCanManager);

    triggerTimer->setSingleShot(false);
    triggerTimer->setInterval(DEFAULT_EW_KEEP_ALIVE_TIMEOUT);

    connect(triggerTimer,SIGNAL(timeout()), this, SLOT(triggerTimeout()));

    triggerTimer->start();
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
    struct can_frame frame_to_send;
    qDebug("KeepALive");

    frame_to_send.can_id = 0x7e0;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = MAJOR_VERSION;
    frame_to_send.data[1] = MINOR_VERSION;
    frame_to_send.data[2] = 0x0;
    frame_to_send.data[3] = 0x0;
    frame_to_send.data[4] = 0x0;
    frame_to_send.data[5] = 0x0;
    frame_to_send.data[6] = 0x0;
    frame_to_send.data[7] = 0x0;

    itsCanManager->write_frame(&frame_to_send);
}

