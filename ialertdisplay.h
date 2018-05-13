#ifndef IALERTDISPLAY_H
#define IALERTDISPLAY_H


#include <QObject>
#include <QMutex>

#include <linux/types.h>
#include <net/if.h>
#include <sys/socket.h>
#include <linux/can.h>


class IAlertDisplay
{

  public:
    virtual void pdz_display(bool) = 0;
    virtual void pcw_display(bool) = 0;


    QMutex mutex;
};


#endif // IALERTDISPLAY_H
