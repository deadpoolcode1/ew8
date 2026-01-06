#ifndef CORE_MUTEX_H
#define CORE_MUTEX_H

#include <mutex>
#include <shared_mutex>
#include <condition_variable>

namespace core {

// Drop-in replacement for QMutex
class Mutex {
public:
    Mutex() = default;

    void lock() { mutex_.lock(); }
    void unlock() { mutex_.unlock(); }
    bool tryLock() { return mutex_.try_lock(); }

    // For compatibility with std::lock_guard and std::unique_lock
    std::mutex& native() { return mutex_; }

private:
    std::mutex mutex_;

    // Non-copyable
    Mutex(const Mutex&) = delete;
    Mutex& operator=(const Mutex&) = delete;
};

// Drop-in replacement for QMutexLocker
class MutexLocker {
public:
    explicit MutexLocker(Mutex* mutex) : mutex_(mutex) {
        if (mutex_) mutex_->lock();
    }

    explicit MutexLocker(Mutex& mutex) : mutex_(&mutex) {
        mutex_->lock();
    }

    ~MutexLocker() {
        if (mutex_) mutex_->unlock();
    }

    void unlock() {
        if (mutex_) {
            mutex_->unlock();
            mutex_ = nullptr;
        }
    }

    void relock() {
        if (mutex_) mutex_->lock();
    }

private:
    Mutex* mutex_;

    // Non-copyable
    MutexLocker(const MutexLocker&) = delete;
    MutexLocker& operator=(const MutexLocker&) = delete;
};

// Drop-in replacement for QReadWriteLock
class ReadWriteLock {
public:
    ReadWriteLock() = default;

    void lockForRead() { mutex_.lock_shared(); }
    void lockForWrite() { mutex_.lock(); }
    void unlock() {
        // Note: std::shared_mutex doesn't have a single unlock that works for both
        // The caller must track which lock they hold
        // For simplicity, we try to unlock both
        try { mutex_.unlock(); } catch(...) {}
        try { mutex_.unlock_shared(); } catch(...) {}
    }
    void unlockRead() { mutex_.unlock_shared(); }
    void unlockWrite() { mutex_.unlock(); }

    bool tryLockForRead() { return mutex_.try_lock_shared(); }
    bool tryLockForWrite() { return mutex_.try_lock(); }

private:
    std::shared_mutex mutex_;

    // Non-copyable
    ReadWriteLock(const ReadWriteLock&) = delete;
    ReadWriteLock& operator=(const ReadWriteLock&) = delete;
};

// Drop-in replacement for QWaitCondition
class WaitCondition {
public:
    WaitCondition() = default;

    void wait(Mutex* mutex) {
        std::unique_lock<std::mutex> lock(mutex->native(), std::adopt_lock);
        cv_.wait(lock);
        lock.release(); // Don't unlock on destruction, QMutex will handle it
    }

    bool wait(Mutex* mutex, unsigned long timeMs) {
        std::unique_lock<std::mutex> lock(mutex->native(), std::adopt_lock);
        bool result = cv_.wait_for(lock, std::chrono::milliseconds(timeMs))
                      == std::cv_status::no_timeout;
        lock.release();
        return result;
    }

    void wakeOne() { cv_.notify_one(); }
    void wakeAll() { cv_.notify_all(); }

private:
    std::condition_variable cv_;

    // Non-copyable
    WaitCondition(const WaitCondition&) = delete;
    WaitCondition& operator=(const WaitCondition&) = delete;
};

} // namespace core

// Core-prefixed typedefs (always available, no conflicts)
using CoreMutex = core::Mutex;
using CoreMutexLocker = core::MutexLocker;
using CoreReadWriteLock = core::ReadWriteLock;
using CoreWaitCondition = core::WaitCondition;

// Qt-compatible typedefs - used by DEFAULT, skipped when USE_QT_BACKEND is defined
#ifndef USE_QT_BACKEND
using QMutex = core::Mutex;
using QMutexLocker = core::MutexLocker;
using QReadWriteLock = core::ReadWriteLock;
using QWaitCondition = core::WaitCondition;
#endif

// Global mutex for convenience (replaces static QMutex usage)
static core::Mutex globalMutex;

#endif // CORE_MUTEX_H
