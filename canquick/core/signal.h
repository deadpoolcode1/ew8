#ifndef CORE_SIGNAL_H
#define CORE_SIGNAL_H

#include <functional>
#include <vector>
#include <memory>
#include <mutex>
#include <algorithm>

namespace core {

// Forward declaration
template<typename... Args>
class Signal;

// Connection handle for disconnecting
class Connection {
public:
    Connection() : id_(0), valid_(false) {}
    Connection(size_t id) : id_(id), valid_(true) {}

    size_t id() const { return id_; }
    bool isValid() const { return valid_; }
    void invalidate() { valid_ = false; }

private:
    size_t id_;
    bool valid_;
};

// Signal class - replacement for Qt signals
// Usage:
//   Signal<int, std::string> mySignal;
//   auto conn = mySignal.connect([](int a, std::string b) { ... });
//   mySignal.emit(42, "hello");
//   mySignal.disconnect(conn);
template<typename... Args>
class Signal {
public:
    using Slot = std::function<void(Args...)>;

    Signal() : nextId_(1) {}

    // Connect a slot (callable)
    Connection connect(Slot slot) {
        std::lock_guard<std::mutex> lock(mutex_);
        size_t id = nextId_++;
        slots_.push_back({id, std::move(slot)});
        return Connection(id);
    }

    // Connect a member function
    template<typename T>
    Connection connect(T* obj, void (T::*method)(Args...)) {
        return connect([obj, method](Args... args) {
            (obj->*method)(std::forward<Args>(args)...);
        });
    }

    // Disconnect by connection handle
    void disconnect(const Connection& conn) {
        if (!conn.isValid()) return;
        std::lock_guard<std::mutex> lock(mutex_);
        slots_.erase(
            std::remove_if(slots_.begin(), slots_.end(),
                [&conn](const SlotEntry& entry) { return entry.id == conn.id(); }),
            slots_.end()
        );
    }

    // Disconnect all slots
    void disconnectAll() {
        std::lock_guard<std::mutex> lock(mutex_);
        slots_.clear();
    }

    // Emit the signal
    void emit(Args... args) {
        std::vector<Slot> slotsCopy;
        {
            std::lock_guard<std::mutex> lock(mutex_);
            slotsCopy.reserve(slots_.size());
            for (const auto& entry : slots_) {
                slotsCopy.push_back(entry.slot);
            }
        }
        for (auto& slot : slotsCopy) {
            slot(std::forward<Args>(args)...);
        }
    }

    // Operator() as alias for emit
    void operator()(Args... args) {
        emit(std::forward<Args>(args)...);
    }

    // Check if any slots are connected
    bool hasConnections() const {
        std::lock_guard<std::mutex> lock(mutex_);
        return !slots_.empty();
    }

    size_t connectionCount() const {
        std::lock_guard<std::mutex> lock(mutex_);
        return slots_.size();
    }

private:
    struct SlotEntry {
        size_t id;
        Slot slot;
    };

    mutable std::mutex mutex_;
    std::vector<SlotEntry> slots_;
    size_t nextId_;
};

// Signal with void return - most common case
using VoidSignal = Signal<>;

} // namespace core

// Macros for Qt-like signal/slot declarations
// Note: These are simplified - full Qt compatibility would require a metacompiler

// Declare a signal in a class
// Usage: CORE_SIGNAL(signalName, int, std::string)
#define CORE_SIGNAL(name, ...) \
    core::Signal<__VA_ARGS__> name

// For signals with no arguments
#define CORE_SIGNAL_VOID(name) \
    core::Signal<> name

// Connect macro (similar to Qt's connect)
#define CORE_CONNECT(sender, signal, receiver, slot) \
    (sender)->signal.connect([receiver](auto&&... args) { \
        (receiver)->slot(std::forward<decltype(args)>(args)...); \
    })

// Emit macro
#define CORE_EMIT(signal, ...) signal.emit(__VA_ARGS__)

#endif // CORE_SIGNAL_H
