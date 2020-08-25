#ifndef WATCHDOGDEVICE_H
#define WATCHDOGDEVICE_H

#include <QObject>


class WatchDogDevice
{
public:
    WatchDogDevice();

    void toggle(void);

private:
    void disarm(void);
    static void sighandler(qint32 signum);
    static qint32 fd;
};

#endif // WATCHDOGDEVICE_H
