// Use core library instead of Qt
#include "core/core.h"
#include "core/thread.h"
#include "core/logger.h"
#include "core/elapsed_timer.h"

#include "ialertdisplay.h"
#include "defs.h"

#include "medisconnectionreport.h"
#include "canrxmsg.h"



MeDisconnectionReport::MeDisconnectionReport(IAlertDisplay * aDisplay)
{
   itsDisplay = aDisplay;

   isInDisconnectionAlert = false;

   connectionTimeoutTimer = new core::Timer();

   connectionTimeoutTimer->setSingleShot(true);
   connectionTimeoutTimer->setInterval(CanRxMsg::getKeepAliveMsgTimeout());

   requestTimeoutTimer = new core::Timer();

   requestTimeoutTimer->setSingleShot(true);
   requestTimeoutTimer->setInterval(1000);


   itsThread = new core::Thread();

   // Connect timer timeouts to handlers
   connectionTimeoutTimer->timeout.connect([this]() {
       fireConnectionTimeout();
   });

   requestTimeoutTimer->timeout.connect([this]() {
       fireRequestTimeout();
   });

   // Start connection timer when thread starts
   itsThread->started.connect([this]() {
       connectionTimeoutTimer->start();
   });

   // Connect signals for request timeout control
   startRequestTimeoutTimer.connect([this]() {
       requestTimeoutTimer->start();
   });

   stopRequestTimeoutTimer.connect([this]() {
       requestTimeoutTimer->stop();
   });
}

void MeDisconnectionReport::launch(void)
{
    itsThread->start();
}

void MeDisconnectionReport::fireRequestTimeout(void)
{
    CanRxMsg::discardRequestId();
    qDebug() << "RIT: Request Id timeout";
#if 1
    itsDisplay->activate(AlertTypes::ALERT_REQFAIL);
    itsDisplay->forceUpdate();
#endif
}

void MeDisconnectionReport::fireConnectionTimeout(void)
{
    isInDisconnectionAlert = true;
    itsDisplay->activate(AlertTypes::ALERT_NOCOM);
    itsDisplay->forceUpdate();
}

void MeDisconnectionReport::resetConnectionTimeout(void)
{
    if(isInDisconnectionAlert)
    {
        itsDisplay->deactivate(AlertTypes::ALERT_NOCOM);
        itsDisplay->forceUpdate();
        isInDisconnectionAlert = false;
    }

    qDebug() << "Disconnection timeout reset at:" << core::ElapsedTimer::currentMSecsSinceEpoch();
    connectionTimeoutTimer->start();
}
