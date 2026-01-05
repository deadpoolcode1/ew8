#ifndef CORE_THREAD_H
#define CORE_THREAD_H

#include <thread>
#include <atomic>
#include <functional>
#include <memory>
#include "signal.h"
#include "mutex.h"

namespace core {

// Drop-in replacement for QThread
class Thread {
public:
    Thread() : running_(false), finished_(false) {}

    virtual ~Thread() {
        if (thread_.joinable()) {
            requestInterruption();
            thread_.join();
        }
    }

    // Start the thread
    void start() {
        if (running_) return;

        running_ = true;
        finished_ = false;
        thread_ = std::thread([this]() {
            started.emit();
            run();
            running_ = false;
            finished_ = true;
            this->finished.emit();
        });
    }

    // Wait for thread to finish
    void wait() {
        if (thread_.joinable()) {
            thread_.join();
        }
    }

    // Wait with timeout (returns true if thread finished)
    bool wait(unsigned long timeMs) {
        // Simple busy-wait implementation
        auto start = std::chrono::steady_clock::now();
        while (!finished_) {
            auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::steady_clock::now() - start).count();
            if (elapsed >= timeMs) return false;
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
        }
        if (thread_.joinable()) thread_.join();
        return true;
    }

    // Check if thread is running
    bool isRunning() const { return running_; }

    // Check if thread has finished
    bool isFinished() const { return finished_; }

    // Request thread interruption
    void requestInterruption() { interruptionRequested_ = true; }

    // Check if interruption was requested
    bool isInterruptionRequested() const { return interruptionRequested_; }

    // Quit the thread (sets interruption flag)
    void quit() { requestInterruption(); }

    // Static method to sleep current thread
    static void msleep(unsigned long msecs) {
        std::this_thread::sleep_for(std::chrono::milliseconds(msecs));
    }

    static void sleep(unsigned long secs) {
        std::this_thread::sleep_for(std::chrono::seconds(secs));
    }

    static void usleep(unsigned long usecs) {
        std::this_thread::sleep_for(std::chrono::microseconds(usecs));
    }

    // Get current thread ID
    static std::thread::id currentThreadId() {
        return std::this_thread::get_id();
    }

    // Signals
    Signal<> started;
    Signal<> finished;

protected:
    // Override this method for custom thread behavior
    virtual void run() {
        // Default implementation - can be overridden
    }

private:
    std::thread thread_;
    std::atomic<bool> running_;
    std::atomic<bool> finished_;
    std::atomic<bool> interruptionRequested_{false};

    // Non-copyable
    Thread(const Thread&) = delete;
    Thread& operator=(const Thread&) = delete;
};

// Worker thread that runs a function
class WorkerThread : public Thread {
public:
    WorkerThread() = default;

    void setWork(std::function<void()> work) {
        work_ = std::move(work);
    }

protected:
    void run() override {
        if (work_) work_();
    }

private:
    std::function<void()> work_;
};

// Thread pool for running multiple tasks
class ThreadPool {
public:
    ThreadPool(size_t numThreads = std::thread::hardware_concurrency())
        : stop_(false) {
        for (size_t i = 0; i < numThreads; ++i) {
            workers_.emplace_back([this] {
                while (true) {
                    std::function<void()> task;
                    {
                        std::unique_lock<std::mutex> lock(queueMutex_);
                        condition_.wait(lock, [this] {
                            return stop_ || !tasks_.empty();
                        });
                        if (stop_ && tasks_.empty()) return;
                        task = std::move(tasks_.front());
                        tasks_.erase(tasks_.begin());
                    }
                    task();
                }
            });
        }
    }

    ~ThreadPool() {
        {
            std::unique_lock<std::mutex> lock(queueMutex_);
            stop_ = true;
        }
        condition_.notify_all();
        for (auto& worker : workers_) {
            if (worker.joinable()) worker.join();
        }
    }

    template<typename F>
    void enqueue(F&& f) {
        {
            std::unique_lock<std::mutex> lock(queueMutex_);
            tasks_.push_back(std::forward<F>(f));
        }
        condition_.notify_one();
    }

private:
    std::vector<std::thread> workers_;
    std::vector<std::function<void()>> tasks_;
    std::mutex queueMutex_;
    std::condition_variable condition_;
    bool stop_;
};

} // namespace core

// Compatibility typedef
using QThread = core::Thread;

#endif // CORE_THREAD_H
