#ifndef CAN_RECEIVER_H
#define CAN_RECEIVER_H

#include "core/signal.h"
#include "core/thread.h"
#include <string>
#include <atomic>

struct can_frame;

/**
 * CAN Receiver - Reads CAN frames from SocketCAN interface
 * and extracts Speed and FCW signals for the LVGL UI.
 *
 * Signal extraction based on DBC files:
 * - Speed: CAN ID 0x760, bits 16-23 (byte 2)
 * - FCW_on: CAN ID 0x700, bit 35 (byte 4, bit 3)
 */
class CanReceiver : public core::Thread {
public:
    explicit CanReceiver(const std::string& interface = "vcan0");
    ~CanReceiver();

    // Signals emitted when CAN data changes
    core::Signal<int> speedChanged;    // Speed value (0-255 km/h)
    core::Signal<bool> fcwChanged;     // FCW active state
    core::Signal<> heartbeatReceived;  // Keep-alive heartbeat received

protected:
    void run() override;

private:
    bool initSocket();
    void parseFrame(const struct can_frame& frame);

    // Signal extraction helpers
    int extractSpeed(const struct can_frame& frame);
    bool extractFCW(const struct can_frame& frame);

    std::string interface_;
    int sockfd_;

    // CAN IDs from basic.sh test and Qt backend JSON config
    static constexpr uint32_t CAN_ID_AWS = 0x700;        // FCW_on at bit 35
    static constexpr uint32_t CAN_ID_SIGNAL_CAR = 0x760; // Speed at bits 16-23
    static constexpr uint32_t CAN_ID_KEEP_ALIVE = 0x412; // Keep-alive (IMS_Status_Protocol_System)
};

#endif // CAN_RECEIVER_H
