#ifndef CORE_ELAPSED_TIMER_H
#define CORE_ELAPSED_TIMER_H

#include <chrono>
#include "types.h"

namespace core {

// Drop-in replacement for QElapsedTimer
class ElapsedTimer {
public:
    ElapsedTimer() : started_(false) {}

    void start() {
        startTime_ = std::chrono::steady_clock::now();
        started_ = true;
    }

    void restart() {
        start();
    }

    void invalidate() {
        started_ = false;
    }

    bool isValid() const {
        return started_;
    }

    // Returns elapsed time in milliseconds
    int64_t elapsed() const {
        if (!started_) return 0;
        auto now = std::chrono::steady_clock::now();
        return std::chrono::duration_cast<std::chrono::milliseconds>(
            now - startTime_).count();
    }

    // Returns elapsed time in nanoseconds
    int64_t nsecsElapsed() const {
        if (!started_) return 0;
        auto now = std::chrono::steady_clock::now();
        return std::chrono::duration_cast<std::chrono::nanoseconds>(
            now - startTime_).count();
    }

    // Check if specified number of milliseconds have passed
    bool hasExpired(int64_t timeout) const {
        return elapsed() >= timeout;
    }

    // Returns milliseconds remaining until timeout (or 0 if expired)
    int64_t remainingTime(int64_t timeout) const {
        int64_t remaining = timeout - elapsed();
        return remaining > 0 ? remaining : 0;
    }

    // Get time since epoch in milliseconds (equivalent to QDateTime::currentMSecsSinceEpoch)
    static int64_t currentMSecsSinceEpoch() {
        auto now = std::chrono::system_clock::now();
        return std::chrono::duration_cast<std::chrono::milliseconds>(
            now.time_since_epoch()).count();
    }

private:
    std::chrono::steady_clock::time_point startTime_;
    bool started_;
};

} // namespace core

// Core-prefixed typedef (always available, no conflicts)
using CoreElapsedTimer = core::ElapsedTimer;

// Qt-compatible typedef - used by DEFAULT, skipped when USE_QT_BACKEND is defined
#ifndef USE_QT_BACKEND
using QElapsedTimer = core::ElapsedTimer;
#endif

#endif // CORE_ELAPSED_TIMER_H
