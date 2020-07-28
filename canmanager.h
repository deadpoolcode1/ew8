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
#include "medisconnectionreport.h"


class IAlertDisplay;
class ICanRxMsgFactory;
class AMSignalsModel;
class MeDisconnectionReport;


class CanManager :  public QObject
{
    Q_OBJECT

public:

    CanManager(IAlertDisplay * alertdisp, QObject * parent = nullptr);
    void read_frame(void);
    void write_frame(struct can_frame * frame_ptr);
    IAlertDisplay * getItsDisplay(void);
    ICanRxMsgFactory * getItsCanRxMsgFactory(void);

    //WARNING: hardcoded!
    //TODO: find what cat be moved to the config files
    void sendVolumeUp(void);
    void sendVolumeDown(void);
    void sendVolumeMute(void);
    void sendVolumeGet(void);

    void launch(void);

signals:
    void resetConnectionTimeout(void);

public slots:
    void process();

private:
    //inner functions:
    void init(void);
    bool parse_frame(struct can_frame * frame);


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
    MeDisconnectionReport * itsDisconnectionReport;
};

#endif // CANMANAGER_H
