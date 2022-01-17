#include "sysreqtype.h"
#include "brightnesscontrol.h"
#include "amjsonsystemrequestaction.h"
#include "canrxmsg.h"
#include "versionmsg.h"
#include "candebugreport.h"
#include "watchdogdevice.h"
#include <QDebug>
#include <QObject>
#include <QProcess>

class VersionMsg;
class SystemRequestType;
class BrightnessControl;
class CANDebugReport;
class WatchDogDevice;

AMJsonSystemRequestAction::AMJsonSystemRequestAction(AMJsonProtocol * aJsonProtocol, QString action, AMJsonAction * parent): AMJsonAction(aJsonProtocol, SystemRequest, action, parent)
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


    case SwitchModeTest:
        if(extractedCANsignal.toBool())
        {
#ifndef WIN32
            WatchDogDevice::disarm();
            QProcess::startDetached(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("bin/canquick -t"));


#elif ! defined(QT_DEBUG)
            QProcess::startDetached(QStringLiteral("release/canquick -t"));

#else
            QProcess::startDetached(QStringLiteral("debug/canquick -t"));
#endif
            exit(0);
        }
        break;

    case SwitchModeAWS:
        if(extractedCANsignal.toBool())
        {
#ifndef WIN32
            WatchDogDevice::disarm();
            QProcess::startDetached(QStringLiteral(BASE_TARGET_DIR)+QStringLiteral("bin/canquick"));

#elif ! defined(QT_DEBUG)
            QProcess::startDetached(QStringLiteral("release/canquick"));

#else
            QProcess::startDetached(QStringLiteral("debug/canquick"));
#endif
            exit(0);
        }
        break;

    default:
        qDebug()<<"Processing unsupported request type";
        break;
    }
}

