#include <stdio.h>
#include <stdlib.h>
#ifndef _WIN32
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/watchdog.h>
#endif
#include <signal.h>
#include "core/core.h"

#include "watchdogdevice.h"

int32_t WatchDogDevice::fd = 0;

int WatchDogDevice::disarm(void)
{
    int ret;

    coreDebug() << "Disabling WDT!";

    ret = write(fd, "V\0", 2);
    if (ret != 1) {
        ret = -1;
    }

    close(fd);

    return ret;
}

void WatchDogDevice::sighandler(int32_t signum)
{
#ifndef WIN32
    int ret;

    if (signum == SIGUSR2)
    {
        ret = disarm();
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
          coreDebug()<<"Failed to toggle linux watchdog device";
    }
#endif
}

WatchDogDevice::WatchDogDevice()
{
 #ifndef WIN32
   signal(SIGUSR2, sighandler);

   fd = open("/dev/watchdog", O_WRONLY);

   if (fd == -1) {
       coreDebug()<< "Watchdog init failed";
   }
   else
   {
     coreDebug()<<"Starting WDT Monitoring";
   }

   int32_t timeout = 1;

   ioctl(fd, WDIOC_SETTIMEOUT, &timeout);
#endif
}
