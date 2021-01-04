#ifndef VERSIONMSG_H
#define VERSIONMSG_H

#include "canmanager.h"

class CanManager;

class VersionMsg
{
public:
    //Single time fired
    static void singleShot(CanManager * aCanManager);
private:
    static void sendVersionInfo(CanManager * aCanManager);
    static void sendServiceNumber(CanManager * aCanManager);
    static void enableDisableSFC(quint32 * wr_ptr, bool On);
    static quint32 readDataSFC(quint32 * rd_ptr, quint32 index);
};

#endif // VERSIONMSG_H
