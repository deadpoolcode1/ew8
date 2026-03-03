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


void AMJsonSystemRequestAction::process(QObject * /*sender*/, Variant extractedCANsignal)
{
    switch (type)
    {
    case GetVersionInfo:

    if (variantToBool(extractedCANsignal))
    {
        VersionMsg::singleShot();
    }
        break;

    case DebugBrightness:
        BrightnessControl::setCANDebugReport(variantToBool(extractedCANsignal));
                break;

    case DebugButtons:
        CANDebugReport::setSendKeyReport(variantToBool(extractedCANsignal));
                break;

    case DebugAlerts:
        CANDebugReport::setSendAlertsReport(variantToBool(extractedCANsignal));
                break;

    case SwitchModeTest:
        if(variantToBool(extractedCANsignal))
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
        if(variantToBool(extractedCANsignal))
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

