#ifndef MEDISCONNECTIONREPORT_H
#define MEDISCONNECTIONREPORT_H

// Use core library instead of Qt
#include "core/core.h"
#include "core/timer.h"
#include "core/thread.h"
#include "core/signal.h"

#include "ialertdisplay.h"

class MeDisconnectionReport
{
public:
    explicit MeDisconnectionReport(IAlertDisplay * itsDisplay);
    void launch(void);

    // Signals (using core::Signal)
    core::Signal<> startRequestTimeoutTimer;
    core::Signal<> stopRequestTimeoutTimer;

    // Slot replacements - now regular methods
    void resetConnectionTimeout(void);
    void fireConnectionTimeout(void);
    void fireRequestTimeout(void);

private:
 bool isInDisconnectionAlert;
 core::Thread * itsThread;
 core::Timer * connectionTimeoutTimer;
 core::Timer * requestTimeoutTimer;
 IAlertDisplay * itsDisplay;
 //TODO set
};

#endif // MEDISCONNECTIONREPORT_H
