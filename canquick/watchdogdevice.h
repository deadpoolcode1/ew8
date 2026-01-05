#ifndef WATCHDOGDEVICE_H
#define WATCHDOGDEVICE_H

#include <QObject>


class WatchDogDevice
{
public:
    WatchDogDevice();

    void toggle(void);

    static int disarm(void);

private:

    static void sighandler(int32_t signum);
    static int32_t fd;
};

#endif // WATCHDOGDEVICE_H
