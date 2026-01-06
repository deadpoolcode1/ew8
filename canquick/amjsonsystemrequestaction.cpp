#include "sysreqtype.h"
#include "brightnesscontrol.h"
#include "amjsonsystemrequestaction.h"
#include "canrxmsg.h"
#include "versionmsg.h"
#include "candebugreport.h"
#include "watchdogdevice.h"
#include "core/core.h"
#include <QObject>

class VersionMsg;
class SystemRequestType;
class BrightnessControl;
class CANDebugReport;
class WatchDogDevice;

AMJsonSystemRequestAction::AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, const String& action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, SystemRequest, action, parent)
{
   type = SystemRequestType::fromString(action);
}


void AMJsonSystemRequestAction::process(QObject * /*sender*/, QVariant extractedCANsignal)
{
    switch (type)
    {
    case GetVersionInfo:

    if (extractedCANsignal.toBool())
    {
        VersionMsg::singleShot();
    }
        break;

    case DebugBrightness:
        BrightnessControl::setCANDebugReport(extractedCANsignal.toBool());
                break;

    case DebugButtons:
        CANDebugReport::setSendKeyReport(extractedCANsignal.toBool());
                break;

    case DebugAlerts:
        CANDebugReport::setSendAlertsReport(extractedCANsignal.toBool());
                break;

    case SwitchModeTest:
        if(extractedCANsignal.toBool())
        {
#ifndef WIN32
            WatchDogDevice::disarm();
            core::Process::startDetached(std::string(BASE_TARGET_DIR) + "bin/canquick", {"-t"});


#elif ! defined(QT_DEBUG)
            core::Process::startDetached("release/canquick", {"-t"});

#else
            core::Process::startDetached("debug/canquick", {"-t"});
#endif
            exit(0);
        }
        break;

    case SwitchModeAWS:
        if(extractedCANsignal.toBool())
        {
#ifndef WIN32
            WatchDogDevice::disarm();
            core::Process::startDetachedCommand(std::string(BASE_TARGET_DIR) + "bin/canquick");

#elif ! defined(QT_DEBUG)
            core::Process::startDetachedCommand("release/canquick");

#else
            core::Process::startDetachedCommand("debug/canquick");
#endif
            exit(0);
        }
        break;

    default:
        coreDebug() << "Processing unsupported request type";
        break;
    }
}

