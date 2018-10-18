#ifndef CANMANAGER_H
#define CANMANAGER_H

#ifndef WIN32
#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>
#else
#include "canlib.h"
#endif

#include "defs.h"


#include <QThread>

#include "ialertdisplay.h"
#include "icanrxmsgfactory.h"


#ifdef WIN32

struct can_frame {
      long can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
      uint    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
      uchar    __pad;   /* padding */
      uchar    __res0;  /* reserved / padding */
      uchar    __res1;  /* reserved / padding */
      uchar    data[8];
};

#endif

typedef struct hmw_state_s
{
    AlertTypes::EnAlert alert;
    //AlertTypes::EnHMW value;
    quint8   value;
    bool is_active;
}
hmw_state_t;

class CanManager :  public QThread
{
    Q_OBJECT

public:

    CanManager(IAlertDisplay * alertdisp);
    void read_frame(void);
    void write_frame(void);

    void run() override;

signals:
    void resultReady(const QString &s);

private:
    //inner functions:
    void init(void);
    void parse_frame(struct can_frame * frame);
     void parse_frame1(struct can_frame * frame);


    struct can_frame prev_frame[CAN_MESSAGES_TYPES_NUM];
    bool is_a_first_frame [CAN_MESSAGES_TYPES_NUM];

    void init_frame(struct can_frame * frame);

    //returns 1 to switch Inactive2Active, -1 to Active2Inactive, 0 to preserve the state:
    qint32 alertStateParseAndCmp(struct can_frame * prev, struct can_frame * recv, quint32 byte, quint8 mask);
    void hmwStateParseAndProcess(struct can_frame * prev, struct can_frame * recv);
    void beamStateParseAndProcess(struct can_frame * prev, struct can_frame * recv);
    void sliStateParseAndProcess(struct can_frame * prev, struct can_frame * recv);

    void hmwStateParse(struct can_frame * frame, hmw_state_t * result);

    bool is_tsr_enabled;


#ifndef WIN32
    //inner variables
    int32_t socknum;
    struct sockaddr_can addr;
    struct ifreq ifr;
    struct can_filter rfilter[CAN_MESSAGES_TYPES_NUM];
#else
    canHandle  hnd;
    canStatus  stat;
#endif

    IAlertDisplay * mydisplays;
    ICanRxMsgFactory * iCanRxMsgFactory;
};

#endif // CANMANAGER_H
