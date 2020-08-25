#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <sys/ioctl.h>
#include <linux/watchdog.h>
#include <signal.h>
#include <QDebug>

#include "watchdogdevice.h"

qint32 WatchDogDevice::fd = 0;

void WatchDogDevice::sighandler(qint32 signum)
{
#ifndef WIN32
    int ret;

    if (signum == SIGUSR2)
    {
        qDebug() << "Disabling WDT!";

        ret = write(fd, "V\0", 2);
        if (ret != 1) {
            ret = -1;
        }

        close(fd);
        //TODO initiate regular exit
        exit(ret);
    }
#endif
}

void WatchDogDevice::toggle(void)
{
#ifndef WIN32
    int status;
    status = write(fd, "\0", 1);
    if (status != 1) {
          qDebug()<<"Failed to toggle linux watchdog device";
    }
#endif
}

WatchDogDevice::WatchDogDevice()
{
 #ifndef WIN32
   signal(SIGUSR2, sighandler);

   fd = open("/dev/watchdog", O_WRONLY);

   if (fd == -1) {
       qDebug()<< "Watchdog init failed";
   }
   else
   {
     qDebug()<<"Starting WDT Monitoring";
   }

   qint32 timeout = 1;

   ioctl(fd, WDIOC_SETTIMEOUT, &timeout);
#endif
}
