#include "can_receiver.h"

#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/can.h>
#include <linux/can/raw.h>
#include <unistd.h>
#include <cstring>
#include <cstdio>

CanReceiver::CanReceiver(const std::string& interface)
    : interface_(interface)
    , sockfd_(-1)
{
}

CanReceiver::~CanReceiver()
{
    // Request thread to stop
    requestInterruption();

    // Close socket to unblock read()
    if (sockfd_ >= 0) {
        shutdown(sockfd_, SHUT_RDWR);
        close(sockfd_);
        sockfd_ = -1;
    }

    // Wait for thread to finish
    wait();
}

bool CanReceiver::initSocket()
{
    // Create CAN socket
    sockfd_ = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (sockfd_ < 0) {
        perror("CAN socket creation failed");
        return false;
    }

    // Get interface index
    struct ifreq ifr;
    std::strncpy(ifr.ifr_name, interface_.c_str(), IFNAMSIZ - 1);
    ifr.ifr_name[IFNAMSIZ - 1] = '\0';

    if (ioctl(sockfd_, SIOCGIFINDEX, &ifr) < 0) {
        perror("CAN ioctl SIOCGIFINDEX failed");
        close(sockfd_);
        sockfd_ = -1;
        return false;
    }

    // Bind socket to CAN interface
    struct sockaddr_can addr;
    std::memset(&addr, 0, sizeof(addr));
    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    if (bind(sockfd_, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("CAN bind failed");
        close(sockfd_);
        sockfd_ = -1;
        return false;
    }

    // Set up CAN filter for our message IDs
    struct can_filter rfilter[3];
    rfilter[0].can_id = CAN_ID_AWS;
    rfilter[0].can_mask = CAN_SFF_MASK;
    rfilter[1].can_id = CAN_ID_SIGNAL_CAR;
    rfilter[1].can_mask = CAN_SFF_MASK;
    rfilter[2].can_id = CAN_ID_KEEP_ALIVE;
    rfilter[2].can_mask = CAN_SFF_MASK;

    if (setsockopt(sockfd_, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, sizeof(rfilter)) < 0) {
        perror("CAN filter setup failed");
        // Continue anyway - filter is optional
    }

    printf("CAN receiver initialized on %s\n", interface_.c_str());
    return true;
}

void CanReceiver::run()
{
    if (!initSocket()) {
        printf("Failed to initialize CAN socket\n");
        return;
    }

    struct can_frame frame;

    while (!isInterruptionRequested()) {
        ssize_t nbytes = read(sockfd_, &frame, sizeof(frame));

        if (nbytes < 0) {
            if (isInterruptionRequested()) {
                break;  // Normal shutdown
            }
            perror("CAN read error");
            continue;
        }

        if (nbytes == sizeof(frame)) {
            parseFrame(frame);
        }
    }

    printf("CAN receiver thread exiting\n");
}

void CanReceiver::parseFrame(const struct can_frame& frame)
{
    printf("parseFrame: CAN ID=0x%03X, len=%d\n", frame.can_id, frame.len);
    fflush(stdout);

    switch (frame.can_id) {
        case CAN_ID_AWS: {  // 0x700
            bool fcw = extractFCW(frame);
            printf("  FCW extracted: %d, firing signal...\n", fcw);
            fflush(stdout);
            fcwChanged.fire(fcw);
            printf("  FCW signal fired\n");
            fflush(stdout);
            break;
        }

        case CAN_ID_SIGNAL_CAR: {  // 0x760
            int speed = extractSpeed(frame);
            printf("  Speed extracted: %d, firing signal...\n", speed);
            fflush(stdout);
            speedChanged.fire(speed);
            printf("  Speed signal fired\n");
            fflush(stdout);
            break;
        }

        case CAN_ID_KEEP_ALIVE: {  // 0x7e0
            printf("  Keep-alive heartbeat received\n");
            fflush(stdout);
            heartbeatReceived.fire();
            break;
        }
    }
}

int CanReceiver::extractSpeed(const struct can_frame& frame)
{
    // Speed: start bit 16, 8 bits (byte 2, full byte)
    // From DBC: SG_ Speed : 16|8@1+ (1,0) [0|255]
    if (frame.len > 2) {
        return static_cast<int>(frame.data[2]);
    }
    return 0;
}

bool CanReceiver::extractFCW(const struct can_frame& frame)
{
    // FCW_on: start bit 35, 1 bit
    // Bit 35 = byte 4 (35/8=4), bit 3 (35%8=3)
    // From DBC: SG_ FCW_on : 35|1@1+ (1,0) [0|1]
    if (frame.len > 4) {
        return (frame.data[4] >> 3) & 0x01;
    }
    return false;
}
