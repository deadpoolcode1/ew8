#ifndef MEDISCONNECTIONREPORT_LVGL_H
#define MEDISCONNECTIONREPORT_LVGL_H

#include "core/timer.h"
#include "core/thread.h"
#include "core/signal.h"

#include "ialertdisplay_core.h"

/**
 * ME Disconnection Report for LVGL
 *
 * Manages the heartbeat timeout detection and triggers ALERT_NOCOM
 * when the connection is lost. This is an adapted version of the
 * Qt backend's MeDisconnectionReport that doesn't depend on CanRxMsg.
 *
 * Usage:
 *   1. Create instance with IAlertDisplay
 *   2. Call launch() to start the timer thread
 *   3. Connect heartbeat signal to resetConnectionTimeout()
 */
class MeDisconnectionReport {
public:
    /**
     * Construct disconnection report
     * @param itsDisplay Alert display for showing ALERT_NOCOM
     * @param timeoutMs Connection timeout in milliseconds (default: 500ms)
     */
    explicit MeDisconnectionReport(IAlertDisplay* itsDisplay,
                                   int timeoutMs = DEFAULT_EW_CAN_CONNECTION_TIMEOUT);
    ~MeDisconnectionReport();

    /**
     * Start the disconnection report (launches timer thread)
     */
    void launch();

    /**
     * Reset the connection timeout
     * Call this when a heartbeat is received
     */
    void resetConnectionTimeout();

    /**
     * Fire the connection timeout
     * Called internally when timeout expires
     */
    void fireConnectionTimeout();

    // Signals (not used in Phase 1, but kept for compatibility)
    core::Signal<> startRequestTimeoutTimer;
    core::Signal<> stopRequestTimeoutTimer;

private:
    bool isInDisconnectionAlert_;
    int timeoutMs_;
    core::Thread* itsThread_;
    core::Timer* connectionTimeoutTimer_;
    IAlertDisplay* itsDisplay_;
};

#endif // MEDISCONNECTIONREPORT_LVGL_H
