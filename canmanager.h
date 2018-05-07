#ifndef CANMANAGER_H
#define CANMANAGER_H

#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>

#include <QThread>

#include "ialertdisplay.h"

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

    //inner variables
    int32_t socknum;
    struct sockaddr_can addr;
    struct ifreq ifr;

    IAlertDisplay * mydisplays;
};

#endif // CANMANAGER_H
