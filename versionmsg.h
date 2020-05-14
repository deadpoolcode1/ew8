#ifndef VERSIONMSG_H
#define VERSIONMSG_H

#include "canmanager.h"

class CanManager;

class VersionMsg
{
public:
    //Single time fired
    static void singleShot(CanManager * aCanManager);
};

#endif // VERSIONMSG_H
