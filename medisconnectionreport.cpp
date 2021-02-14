#include <QThread>
#include <QDebug>

#include "ialertdisplay.h"
#include "defs.h"

#include "medisconnectionreport.h"
#include "canrxmsg.h"
#include <QDateTime>



MeDisconnectionReport::MeDisconnectionReport(IAlertDisplay * aDisplay, QObject *parent) : QObject(parent)
{
   itsDisplay = aDisplay;

   isInDisconnectionAlert = false;

   connectionTimeoutTimer = new QTimer();

   connectionTimeoutTimer->setSingleShot(true);
   connectionTimeoutTimer->setInterval(CanRxMsg::getKeepAliveMsgTimeout());
   connectionTimeoutTimer->setTimerType(Qt::PreciseTimer);

   requestTimeoutTimer = new QTimer();

   requestTimeoutTimer->setSingleShot(true);
   requestTimeoutTimer->setInterval(1000);
   requestTimeoutTimer->setTimerType(Qt::PreciseTimer);


   itsThread = new QThread();
   this->moveToThread(itsThread);
   connectionTimeoutTimer->moveToThread(itsThread);
   requestTimeoutTimer->moveToThread(itsThread);

   connect(connectionTimeoutTimer,SIGNAL(timeout()), this, SLOT(fireConnectionTimeout()));
   connect(itsThread,SIGNAL(started()), connectionTimeoutTimer, SLOT(start()));

   connect(this, SIGNAL(startRequestTimeoutTimer()), requestTimeoutTimer, SLOT(start()));
   connect(this, SIGNAL(stopRequestTimeoutTimer()), requestTimeoutTimer, SLOT(stop()));
   connect(requestTimeoutTimer, SIGNAL(timeout()), this, SLOT(fireRequestTimeout()));
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

    qDebug()<<"Disconnection timeout reset at:" <<  QDateTime::currentMSecsSinceEpoch();
    connectionTimeoutTimer->start();
}
