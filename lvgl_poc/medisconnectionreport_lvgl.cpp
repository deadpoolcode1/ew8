#include "medisconnectionreport_lvgl.h"
#include "core/elapsed_timer.h"
#include <cstdio>

MeDisconnectionReport::MeDisconnectionReport(IAlertDisplay* aDisplay, int timeoutMs)
    : isInDisconnectionAlert_(false)
    , timeoutMs_(timeoutMs)
    , itsThread_(nullptr)
    , connectionTimeoutTimer_(nullptr)
    , itsDisplay_(aDisplay)
{
    connectionTimeoutTimer_ = new core::Timer();
    connectionTimeoutTimer_->setSingleShot(true);
    connectionTimeoutTimer_->setInterval(timeoutMs_);

    itsThread_ = new core::Thread();

    // Connect timer timeout to handler
    connectionTimeoutTimer_->timeout.connect([this]() {
        fireConnectionTimeout();
    });

    // Start connection timer when thread starts
    itsThread_->started.connect([this]() {
        printf("MeDisconnectionReport: Thread started, starting connection timer (%d ms)\n", timeoutMs_);
        fflush(stdout);
        connectionTimeoutTimer_->start();
    });
}

MeDisconnectionReport::~MeDisconnectionReport()
{
    if (connectionTimeoutTimer_) {
        connectionTimeoutTimer_->stop();
        delete connectionTimeoutTimer_;
    }
    if (itsThread_) {
        itsThread_->quit();
        itsThread_->wait();
        delete itsThread_;
    }
}

void MeDisconnectionReport::launch()
{
    printf("MeDisconnectionReport: Launching timer thread\n");
    fflush(stdout);
    itsThread_->start();
}

void MeDisconnectionReport::fireConnectionTimeout()
{
    printf("MeDisconnectionReport: Connection timeout fired!\n");
    fflush(stdout);

    isInDisconnectionAlert_ = true;
    itsDisplay_->activate(AlertTypes::ALERT_NOCOM);
    itsDisplay_->forceUpdate();
}

void MeDisconnectionReport::resetConnectionTimeout()
{
    if (isInDisconnectionAlert_) {
        printf("MeDisconnectionReport: Connection restored, deactivating ALERT_NOCOM\n");
        fflush(stdout);

        itsDisplay_->deactivate(AlertTypes::ALERT_NOCOM);
        itsDisplay_->forceUpdate();
        isInDisconnectionAlert_ = false;
    }

    printf("MeDisconnectionReport: Disconnection timeout reset at: %lld\n",
           (long long)core::ElapsedTimer::currentMSecsSinceEpoch());
    fflush(stdout);

    connectionTimeoutTimer_->start();
}
