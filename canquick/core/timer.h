#ifndef CORE_TIMER_H
#define CORE_TIMER_H

#include <thread>
#include <atomic>
#include <chrono>
#include <functional>
#include <mutex>
#include <condition_variable>
#include "signal.h"

namespace core {

// Drop-in replacement for QTimer
class Timer {
public:
    Timer() : interval_(0), singleShot_(false), active_(false) {}

    ~Timer() {
        stop();
    }

    // Set interval in milliseconds
    void setInterval(int msec) {
        interval_ = msec;
    }

    int interval() const {
        return interval_;
    }

    // Set single shot mode
    void setSingleShot(bool singleShot) {
        singleShot_ = singleShot;
    }

    bool isSingleShot() const {
        return singleShot_;
    }

    // Check if timer is active
    bool isActive() const {
        return active_;
    }

    // Start the timer
    void start() {
        if (interval_ <= 0) return;
        start(interval_);
    }

    void start(int msec) {
        stop(); // Stop any existing timer

        interval_ = msec;
        active_ = true;
        stopRequested_ = false;

        timerThread_ = std::thread([this]() {
            while (!stopRequested_) {
                {
                    std::unique_lock<std::mutex> lock(mutex_);
                    if (cv_.wait_for(lock, std::chrono::milliseconds(interval_),
                                     [this] { return stopRequested_.load(); })) {
                        break; // Stop was requested
                    }
                }

                if (!stopRequested_) {
                    timeout.emit();

                    if (singleShot_) {
                        active_ = false;
                        break;
                    }
                }
            }
        });
    }

    // Stop the timer
    void stop() {
        if (!active_ && !timerThread_.joinable()) return;

        stopRequested_ = true;
        cv_.notify_all();

        if (timerThread_.joinable()) {
            timerThread_.join();
        }

        active_ = false;
    }

    // Remaining time until next timeout
    int remainingTime() const {
        // Simplified - would need more state tracking for accurate value
        return active_ ? interval_ : -1;
    }

    // Static single shot timer
    static void singleShot(int msec, std::function<void()> callback) {
        std::thread([msec, callback]() {
            std::this_thread::sleep_for(std::chrono::milliseconds(msec));
            callback();
        }).detach();
    }

    // Timeout signal - emitted when timer fires
    Signal<> timeout;

private:
    int interval_;
    bool singleShot_;
    std::atomic<bool> active_;
    std::atomic<bool> stopRequested_{false};
    std::thread timerThread_;
    std::mutex mutex_;
    std::condition_variable cv_;

    // Non-copyable
    Timer(const Timer&) = delete;
    Timer& operator=(const Timer&) = delete;
};

// Convenience class for periodic callbacks without signals
class PeriodicTimer {
public:
    PeriodicTimer() : running_(false) {}

    ~PeriodicTimer() {
        stop();
    }

    void start(int intervalMs, std::function<void()> callback) {
        stop();
        running_ = true;
        thread_ = std::thread([this, intervalMs, callback]() {
            while (running_) {
                std::this_thread::sleep_for(std::chrono::milliseconds(intervalMs));
                if (running_) callback();
            }
        });
    }

    void stop() {
        running_ = false;
        if (thread_.joinable()) {
            thread_.join();
        }
    }

    bool isRunning() const { return running_; }

private:
    std::atomic<bool> running_;
    std::thread thread_;
};

// One-shot delayed callback
class DelayedCallback {
public:
    DelayedCallback() : pending_(false) {}

    ~DelayedCallback() {
        cancel();
    }

    void schedule(int delayMs, std::function<void()> callback) {
        cancel();
        pending_ = true;
        thread_ = std::thread([this, delayMs, callback]() {
            std::this_thread::sleep_for(std::chrono::milliseconds(delayMs));
            if (pending_) {
                pending_ = false;
                callback();
            }
        });
    }

    void cancel() {
        pending_ = false;
        if (thread_.joinable()) {
            thread_.join();
        }
    }

    bool isPending() const { return pending_; }

private:
    std::atomic<bool> pending_;
    std::thread thread_;
};

} // namespace core

// Compatibility typedef
using QTimer = core::Timer;

#endif // CORE_TIMER_H
