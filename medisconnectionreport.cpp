#include <QThread>
#include <QDebug>

#include "ialertdisplay.h"
#include "defs.h"

#include "medisconnectionreport.h"



MeDisconnectionReport::MeDisconnectionReport(IAlertDisplay * aDisplay, QObject *parent) : QObject(parent)
{
   itsDisplay = aDisplay;

   isInDisconnectionAlert = false;

   timeoutTimer = new QTimer();

   timeoutTimer->setSingleShot(true);
   timeoutTimer->setInterval(DEFAULT_EW_CAN_CONNECTION_TIMEOUT);
   timeoutTimer->setTimerType(Qt::PreciseTimer);

   itsThread = new QThread();
   this->moveToThread(itsThread);
   timeoutTimer->moveToThread(itsThread);

#if 0
   connect(this, SIGNAL(timeoutStart()), timeoutTimer, SLOT(start()));
   connect(this, SIGNAL(timeoutStop()), timeoutTimer, SLOT(stop()));
#endif
   connect(timeoutTimer,SIGNAL(timeout()), this, SLOT(fireConnectionTimeout()));
   connect(itsThread,SIGNAL(started()), timeoutTimer, SLOT(start()));



}

void MeDisconnectionReport::launch(void)
{
    itsThread->start();
}

void MeDisconnectionReport::fireConnectionTimeout(void)
{
    qDebug() << "Disconnection Alert! at:" << bootUpTimer.elapsed();
    qDebug() << "timeout timer:" << timeoutTimer->remainingTime();
    isInDisconnectionAlert = true;
    itsDisplay->activate(AlertTypes::ALERT_NOCOM);
}

void MeDisconnectionReport::resetConnectionTimeout(void)
{
#if 0
    if(timeoutTimer->isActive())
    {
        timeoutTimer->stop();
        //timeoutStop();
    }
#endif

    if(isInDisconnectionAlert)
    {
        qDebug() << "CAN interface reconnected at" << bootUpTimer.elapsed();
        itsDisplay->deactivate(AlertTypes::ALERT_NOCOM);
        isInDisconnectionAlert = false;
    }

    timeoutTimer->start();
    qDebug() << "timeout timer:" << timeoutTimer->remainingTime();
    //timeoutStart();
}
