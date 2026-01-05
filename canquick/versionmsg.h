#ifndef VERSIONMSG_H
#define VERSIONMSG_H

#include "canmanager.h"

class CanManager;

class VersionMsg
{
public:
    //Single time fired
    static void create(CanManager * aCanManager);
    static void singleShot(void);
private:

    static VersionMsg * instance;

    VersionMsg(CanManager * aCanManager);

    void sendAll(void);

    CanManager * itsCanManager;
    struct can_frame version2send;
    void readVersionInfo(void);
#ifndef WIN32
    void readServiceNumber(void);
    void enableDisableSFC(uint32_t * wr_ptr, bool On);
    uint32_t readDataSFC(uint32_t * rd_ptr, uint32_t index);

    struct can_frame sn2send_LSB;
    struct can_frame sn2send_MSB;
#endif
};

#endif // VERSIONMSG_H
