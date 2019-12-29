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
#include <QTimer>

#include "ialertdisplay.h"
#include "icanrxmsgfactory.h"
#include "amsignalsmodel.h"


class IAlertDisplay;
class ICanRxMsgFactory;
class AMSignalsModel;

class CanManager :  public QObject
{
    Q_OBJECT

public:

    CanManager(IAlertDisplay * alertdisp, QObject * parent = nullptr);
    void read_frame(void);
    void write_frame(struct can_frame * frame_ptr);
    IAlertDisplay * getItsDisplay(void);
    ICanRxMsgFactory * getItsCanRxMsgFactory(void);
    void launch(void);

    void setConnectionTimeoutMsec(quint32 aTimeout);


public slots:
    void process();
    void fireConnectionTimeout();

private:
    //inner functions:
    void init(void);
    bool parse_frame(struct can_frame * frame);
    void init_frame(struct can_frame * frame);
    void resetConnectionTimeout(void);

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

    IAlertDisplay * itsDisplay;
    ICanRxMsgFactory * itsCanRxMsgFactory;
    AMSignalsModel * amSignalsModel;
    QThread * itsThread;

    QTimer * timeoutTimer;
    bool isInDisconnectionAlert;

};

#endif // CANMANAGER_H
