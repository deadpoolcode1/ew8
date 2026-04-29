#include <string.h>
#include <stdio.h>
#include "defs.h"

#include "core/core.h"

#include "candbsignal.h"

#if defined(_WIN32)
// Windows: UDP virtual CAN + runtime Kvaser auto-detection
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#pragma comment(lib, "ws2_32.lib")

// Kvaser canlib function signatures (resolved at runtime via LoadLibrary)
typedef void   (__stdcall *pfn_canInitializeLibrary)(void);
typedef int    (__stdcall *pfn_canGetNumberOfChannels)(int* channelCount);
typedef int    (__stdcall *pfn_canOpenChannel)(int channel, int flags);
typedef int    (__stdcall *pfn_canSetBusParams)(int hnd, long freq, unsigned int tseg1, unsigned int tseg2, unsigned int sjw, unsigned int noSamp, unsigned int syncmode);
typedef int    (__stdcall *pfn_canBusOn)(int hnd);
typedef int    (__stdcall *pfn_canBusOff)(int hnd);
typedef int    (__stdcall *pfn_canClose)(int hnd);
typedef int    (__stdcall *pfn_canReadWait)(int hnd, long* id, void* msg, unsigned int* dlc, unsigned int* flag, unsigned long* time, unsigned long timeout);
typedef int    (__stdcall *pfn_canWriteWait)(int hnd, long id, void* msg, unsigned int dlc, unsigned int flag, unsigned long timeout);

// Kvaser constants (from canlib.h — duplicated here to avoid SDK dependency)
static constexpr int canOK = 0;
static constexpr int canOPEN_ACCEPT_VIRTUAL = 0x0020;
static constexpr int canMSG_STD = 0x0002;
static constexpr int canMSG_ERROR_FRAME = 0x0020;
static constexpr long canBITRATE_1M   = -1;
static constexpr long canBITRATE_500K = -2;
static constexpr long canBITRATE_250K = -3;
static constexpr long canBITRATE_125K = -4;

// Runtime-loaded Kvaser function pointers
static struct {
    HMODULE dll;
    pfn_canInitializeLibrary    canInitializeLibrary;
    pfn_canGetNumberOfChannels  canGetNumberOfChannels;
    pfn_canOpenChannel          canOpenChannel;
    pfn_canSetBusParams         canSetBusParams;
    pfn_canBusOn                canBusOn;
    pfn_canBusOff               canBusOff;
    pfn_canClose                canClose;
    pfn_canReadWait             canReadWait;
    pfn_canWriteWait            canWriteWait;
} kvaser = {};

static bool loadKvaserDll()
{
    kvaser.dll = LoadLibraryA("canlib32.dll");
    if (!kvaser.dll) return false;

    #define LOAD_FN(name) \
        kvaser.name = (pfn_##name)GetProcAddress(kvaser.dll, #name); \
        if (!kvaser.name) { FreeLibrary(kvaser.dll); kvaser.dll = nullptr; return false; }

    LOAD_FN(canInitializeLibrary)
    LOAD_FN(canGetNumberOfChannels)
    LOAD_FN(canOpenChannel)
    LOAD_FN(canSetBusParams)
    LOAD_FN(canBusOn)
    LOAD_FN(canBusOff)
    LOAD_FN(canClose)
    LOAD_FN(canReadWait)
    LOAD_FN(canWriteWait)

    #undef LOAD_FN
    return true;
}

#else
#include <unistd.h>
#include <linux/can/netlink.h>
#include <libsocketcan.h>

#include <net/if.h>
#include <linux/types.h>

#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/uio.h>

#include <linux/can.h>
#include <linux/can/raw.h>

#include <fcntl.h>
#include <errno.h>
#endif


#include "core/thread.h"
#include "core/mutex.h"
#include "core/timer.h"
#include "core/elapsed_timer.h"
#include "core/json.h"

#include "ialertdisplay.h"
#include "icanrxmsgfactory.h"
#include "canrxmsgfactory.h"
#include "canrxmsg.h"
#include "keepalivemsg.h"
#include "versionmsg.h"
#include "medisconnectionreport.h"

#include "canmanager.h"
#include "amjsonconfigreader.h"

class AMJsonConfigReader;

#if !defined(_WIN32)
    #ifndef VIRTUAL_CAN0
    const char * CanManager::can_if_name = "can0";
    #else
    const char * CanManager::can_if_name = "vcan0";
    #endif
#endif

CanManager::CanManager(IAlertDisplay * alertdisp)
    : itsThread(nullptr)
{
    itsDisplay = alertdisp;

    init();

    KeepAliveMsg::create(this);


    itsDisconnectionReport = new MeDisconnectionReport(alertdisp);

    CanRxMsg::setItsDisconnectionReport(itsDisconnectionReport);

    // Connect signal to MeDisconnectionReport using core::Signal
    resetConnectionTimeoutSignal.connect([this]() {
        itsDisconnectionReport->resetConnectionTimeout();
    });

    // Create thread - will be started in launch()
    itsThread = new core::Thread();
}

CanManager::~CanManager()
{
    if (itsThread) {
        itsThread->quit();
        itsThread->wait();
        delete itsThread;
    }
    delete itsDisconnectionReport;

#if defined(_WIN32)
    if (useKvaser_) {
        if (kvaserPeerThread_) {
            kvaserPeerStop_ = true;
            // The reader is in a 100ms canReadWait — let it finish naturally.
            // We don't join (core::Thread blocking semantics vary); the
            // process is exiting anyway.
            kvaserPeerThread_ = nullptr;
        }
        if (kvaserPeerHandle_ >= 0 && kvaser.canBusOff) {
            kvaser.canBusOff(kvaserPeerHandle_);
            kvaser.canClose(kvaserPeerHandle_);
        }
        if (kvaser.canBusOff) kvaser.canBusOff(kvaserHandle_);
        if (kvaser.canClose) kvaser.canClose(kvaserHandle_);
        if (kvaserDll_) FreeLibrary(kvaserDll_);
    } else {
        closesocket(udpSock_);
        WSACleanup();
    }
#endif
}

void CanManager::launch(void)
{
    VersionMsg::create(this);
    VersionMsg::singleShot();
    itsDisconnectionReport->launch();

    // Start thread with process() as the run function
    itsThread->started.connect([this]() {
        process();
    });
    itsThread->start();
}

//TODO: unite volume functions
void CanManager::sendVolumeDown(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x0)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);


    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendVolumeUp(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x1)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}


void CanManager::sendVolumeGet(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x2)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendVolumeMute(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x3)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAFullDeact()
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x5)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAPartDeact(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x4)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}

void CanManager::sendISAFullActivate(void)
{
    uint16_t requestId = rand()%0xffff;

    struct can_frame frame_to_send;

    memset(frame_to_send.data,0xff,8);

    frame_to_send.can_id = 0x733;
    frame_to_send.can_dlc = 8;
    frame_to_send.data[0] = (uint8_t)((requestId >> 000) & 0xff);;
    frame_to_send.data[1] = (uint8_t)((requestId >> 010) & 0xff);
    frame_to_send.data[2] = (0x6)|(0xf8);

    frame_to_send.data[3] = (0xff);
    frame_to_send.data[4] = (0xff);
    frame_to_send.data[5] = (0xff);
    frame_to_send.data[6] = (0xff);
    frame_to_send.data[7] = (0xff);

    write_frame(&frame_to_send);

    CanRxMsg::expectRequestId(requestId);
}




 IAlertDisplay * CanManager::getItsDisplay(void)
 {
    return itsDisplay;
 }

 ICanRxMsgFactory * CanManager::getItsCanRxMsgFactory(void)
 {
     return itsCanRxMsgFactory;
 }


void CanManager::init(void)
{
    itsCanRxMsgFactory = new CanRxMsgFactory();

    amSignalsModel = new AMSignalsModel(this);

    CanRxMsg::completeInitCanRxMsgsPool();

    //"CANBusParameters":
    //{
    //    "baudrateKbps": 500,
    //    "samplePoint": 87.5
    //}

    int32_t bdr = 500;
    double samplepnt = 87.5;

    core::JsonValue canbus_jtop = AMJsonConfigReader::getInstance()->getJsonTopEntry("CANBusParameters");

    if (canbus_jtop.isUndefined())
    {
        coreDebug() << "CANBusParameters entry is not found, using default values.";
    }
    else
    {
        core::JsonObject canbus_jobj = canbus_jtop.toObject();


        core::JsonValue baudrate_entry = canbus_jobj["baudrateKbps"];

        //NOTE: sample point % configuration used in Linux only:
        core::JsonValue samplepoint_entry = canbus_jobj["samplePoint"];

        if (baudrate_entry.isUndefined())
        {
            coreDebug() << "Baudrate entry is not found, using default value.";
        }
        else
        {
            bdr = baudrate_entry.toInt(500);
        }

        double samplepoint_tmp;

        if (samplepoint_entry.isUndefined())
        {
            coreDebug() << "Sample point entry is not found, using default value.";
        }
        else
        {
            samplepoint_tmp = samplepoint_entry.toDouble(87.5);

            if (samplepoint_tmp > 100 or samplepoint_tmp < 0)
            {
                coreDebug() << "CAN samplepoint in config file is not valid, using default value";
            }
            else
            {
                samplepnt = samplepoint_tmp;
            }
        }
    }


    coreDebug() << "CAN SamplePoint:" << samplepnt << "% (Linux Only)";

#if defined(_WIN32)
    // Always bind the UDP virtual-CAN socket so test tools (cansend.py via
    // UDP, the e2e_test UDP phase, etc.) keep working regardless of whether
    // a Kvaser adapter is also present. Kvaser is then enabled in addition
    // when canlib32.dll is loadable; both transports feed into parse_frame.
    initUdp();
    useKvaser_ = tryInitKvaser(bdr);
    if (useKvaser_) {
        coreDebug() << "Using Kvaser CAN hardware (+ UDP virtual CAN)";
    } else {
        coreDebug() << "No Kvaser adapter found, using UDP virtual CAN only";
    }
#else

    //CAN interface configuration:

    int can_err_status;

    can_err_status = can_do_stop(can_if_name);

    if(can_err_status)
    {
        coreDebug() << "failed can interface stop";
    }
    else
    {
        //set parameters:
        switch (bdr)
        {
        case 1000:
             coreDebug() << "CAN Baudrate:" << bdr << "kbps";
             break;
        case 500:
            coreDebug() << "CAN Baudrate:" << bdr << "kbps";
            break;
        case 250:
            coreDebug() << "CAN Baudrate:" << bdr << "kbps";
            break;

        case 125:
            coreDebug() << "CAN Baudrate:" << bdr << "kbps";
            break;

        default:
            coreDebug() << "CAN Baudrate in config file is not valid, set to 500K";
            bdr = 500;
        }



        can_err_status = can_set_bitrate_samplepoint(can_if_name, bdr * 1000, samplepnt / 100);

        struct can_ctrlmode cm =
        {
            .mask = 0x00,
            .flags = 0x80, // CAN_CTRLMODE_FD_NON_ISO,
        };

        can_err_status |= can_set_ctrlmode(can_if_name, &cm);


        if(can_err_status)
        {
            coreDebug() << "can parameters configuration failed";
        }
        else
        {
            can_err_status = can_do_start(can_if_name);

            if(can_err_status)
            {
                coreDebug() << "failed can interface start";
            }
        }
    }

    if(!can_err_status)
    {
      coreDebug() << "Can interface configuration succeed";
    }



    //CAN Socket configuration:

    const List<CanStdId_t> rfilterList = CanRxMsg::getMsgsWhiteList();

    size_t rfilterSize = rfilterList.size();

    struct can_filter rfilter [rfilterSize];

    for (size_t i = 0; i < rfilterSize; i++)
    {
           rfilter[i].can_id = rfilterList.at(i);
           rfilter[i].can_mask = CAN_SFF_MASK;
    }

    socknum = socket(PF_CAN, SOCK_RAW, CAN_RAW);

#if 0
    int32_t status = 0;

    int32_t flags = fcntl(socknum, F_GETFL);


    if(-1 != flags)
    {
        status = fcntl(socknum, F_SETFL, flags | O_NONBLOCK);
    }
    else
    {

    }

    if(-1 == status)
    {
        coreDebug() << "Unsuccess on NONBLOCKINK CAN socket configure";
    }
#endif


    setsockopt(socknum, SOL_CAN_RAW, CAN_RAW_FILTER, &rfilter, rfilterSize * sizeof(struct can_filter));

    strcpy(ifr.ifr_name, can_if_name);
    ioctl(socknum, SIOCGIFINDEX, &ifr);

    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    bind(socknum, (struct sockaddr *)&addr, sizeof(addr));
    coreDebug() << "can interface initiated";
#endif
}

void CanManager::read_frame(void)
{
#if defined(_WIN32)
    // On Windows we always have UDP bound, and when canlib is present we
    // also have the Kvaser path. Drain UDP first (non-blocking, so this is
    // ~free when there's no traffic), then service Kvaser.
    if (udpSock_ != INVALID_SOCKET) {
        // UDP Virtual CAN: receive 13-byte packet [4B id LE][1B dlc][8B data]
        uint8_t buf[13];
        struct sockaddr_in srcAddr;
        int srcLen = sizeof(srcAddr);

        int nbytes = recvfrom(udpSock_, reinterpret_cast<char*>(buf), sizeof(buf), 0,
                              reinterpret_cast<struct sockaddr*>(&srcAddr), &srcLen);

        if (nbytes >= 13) {
            struct can_frame frame;
            frame.can_id = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
            frame.can_dlc = buf[4];
            if (frame.can_dlc > 8) frame.can_dlc = 8;
            memcpy(frame.data, buf + 5, 8);

            coreDebug() << "udp-vcan rx:" << (void*) static_cast<uintptr_t>(frame.can_id) << ":"
                       << (void*) static_cast<uintptr_t>(frame.data[0])
                       << (void*) static_cast<uintptr_t>(frame.data[1])
                       << (void*) static_cast<uintptr_t>(frame.data[2])
                       << (void*) static_cast<uintptr_t>(frame.data[3])
                       << (void*) static_cast<uintptr_t>(frame.data[4])
                       << (void*) static_cast<uintptr_t>(frame.data[5])
                       << (void*) static_cast<uintptr_t>(frame.data[6])
                       << (void*) static_cast<uintptr_t>(frame.data[7])
                       << "ts:" << core::ElapsedTimer::currentMSecsSinceEpoch();

            parse_frame(&frame);
        }
    }

    if (useKvaser_) {
        // Kvaser hardware / virtual CAN
        struct can_frame frame;
        unsigned int flags;
        unsigned long time;

        int stat = kvaser.canReadWait(kvaserHandle_, &(frame.can_id), (frame.data),
                                      &(frame.can_dlc), &flags, &time, 10);
        if (stat == canOK) {
            if (flags & canMSG_ERROR_FRAME) {
                printf("***ERROR FRAME RECEIVED***");
            } else {
                parse_frame(&frame);
            }
        }
    }
#else
    struct can_frame frame;
    ssize_t nbytes = 0;

    nbytes = read(socknum, &frame, sizeof(struct can_frame));

    if (nbytes < 0) {
         //skip
    }
    else if (nbytes < (ssize_t)sizeof(struct can_frame))
    {
        fprintf(stderr, "read: incomplete CAN frame\n");
    }
    else
    {
        coreDebug() << "can interface:" << (void*) static_cast<uintptr_t>(frame.can_id) << ":" <<
                   (void*) static_cast<uintptr_t>(frame.data[0]) <<
                   (void*) static_cast<uintptr_t>(frame.data[1]) <<
                   (void*) static_cast<uintptr_t>(frame.data[2]) <<
                   (void*) static_cast<uintptr_t>(frame.data[3]) <<
                   (void*) static_cast<uintptr_t>(frame.data[4]) <<
                   (void*) static_cast<uintptr_t>(frame.data[5]) <<
                   (void*) static_cast<uintptr_t>(frame.data[6]) <<
                   (void*) static_cast<uintptr_t>(frame.data[7]) <<
                   "ts:" << core::ElapsedTimer::currentMSecsSinceEpoch();

        parse_frame(&frame);
    }
#endif
}

void CanManager::write_frame(struct can_frame * frame_ptr)
{
#if defined(_WIN32)
    if (useKvaser_) {
        // Kvaser hardware CAN. Timeout is generous (1 s): on a virtual bus
        // with no peer the controller may take tens of ms to give up; 10 ms
        // was producing canERR_TIMEOUT (-7) intermittently at startup.
        unsigned int flags = canMSG_STD;
        int stat = kvaser.canWriteWait(kvaserHandle_, (frame_ptr->can_id), (frame_ptr->data), (frame_ptr->can_dlc), flags, 1000);
        if (stat != canOK) {
            // Diagnostic goes to a dedicated file so it survives even when stdio is
            // redirected/buffered or the launcher swallows stderr.
            // Common stat: -2 canERR_TIMEOUT (queue full / no ack), -10 canERR_INVHANDLE,
            // -13 canERR_TXBUFOFL, -20 canERR_HARDWARE (often bus-off), -27 canERR_NOTFOUND.
            static FILE* s_diag = nullptr;
            static unsigned long s_failCount = 0;
            static unsigned long s_lastReport = 0;
            if (!s_diag) {
                // Written to current working directory (= build dir when
                // launched from there). e2e_test.py reads from build_win/.
                s_diag = fopen("kvaser_diag.log", "w");
                if (s_diag) {
                    fprintf(s_diag, "# canmanager kvaser TX diagnostic\n");
                    fflush(s_diag);
                }
            }
            ++s_failCount;
            if (s_diag && (s_failCount <= 20 || s_failCount - s_lastReport >= 100)) {
                fprintf(s_diag,
                        "[KVASER TX FAILED] id=0x%lX dlc=%u stat=%d count=%lu\n",
                        (unsigned long)frame_ptr->can_id,
                        (unsigned)frame_ptr->can_dlc, stat, s_failCount);
                fflush(s_diag);
                s_lastReport = s_failCount;
            }
        }
    } else {
        // UDP Virtual CAN: send 13-byte packet to TX port
        uint8_t buf[13];
        buf[0] = (frame_ptr->can_id >>  0) & 0xFF;
        buf[1] = (frame_ptr->can_id >>  8) & 0xFF;
        buf[2] = (frame_ptr->can_id >> 16) & 0xFF;
        buf[3] = (frame_ptr->can_id >> 24) & 0xFF;
        buf[4] = frame_ptr->can_dlc;
        memcpy(buf + 5, frame_ptr->data, 8);

        struct sockaddr_in txAddr;
        memset(&txAddr, 0, sizeof(txAddr));
        txAddr.sin_family = AF_INET;
        txAddr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        txAddr.sin_port = htons(UDP_CAN_TX_PORT);

        sendto(udpSock_, reinterpret_cast<const char*>(buf), 13, 0,
               reinterpret_cast<struct sockaddr*>(&txAddr), sizeof(txAddr));
    }
#else
    ssize_t nbytes = 0;

    nbytes = write(socknum, frame_ptr, sizeof(struct can_frame));

    if (nbytes < 0) {
         coreDebug() << "Can not write to the CAN bus socket!";
    }
#endif
}

#if defined(_WIN32)
void CanManager::initUdp()
{
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        coreDebug() << "WSAStartup failed";
        return;
    }

    udpSock_ = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (udpSock_ == INVALID_SOCKET) {
        coreDebug() << "Failed to create UDP socket for virtual CAN";
        return;
    }

    int optval = 1;
    setsockopt(udpSock_, SOL_SOCKET, SO_REUSEADDR,
               reinterpret_cast<const char*>(&optval), sizeof(optval));

    memset(&udpAddr_, 0, sizeof(udpAddr_));
    udpAddr_.sin_family = AF_INET;
    udpAddr_.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    udpAddr_.sin_port = htons(UDP_CAN_PORT);

    if (bind(udpSock_, reinterpret_cast<struct sockaddr*>(&udpAddr_),
             sizeof(udpAddr_)) == SOCKET_ERROR) {
        coreDebug() << "Failed to bind UDP virtual CAN socket on port" << UDP_CAN_PORT;
    } else {
        coreDebug() << "UDP virtual CAN listening on port" << UDP_CAN_PORT;
    }

    // Non-blocking — when Kvaser is also active we poll both transports from
    // the same read loop, so UDP recvfrom must return immediately when no
    // packet is queued.
    u_long nonblock = 1;
    ioctlsocket(udpSock_, FIONBIO, &nonblock);
}

bool CanManager::tryInitKvaser(int32_t bdr)
{
    if (!loadKvaserDll()) {
        coreDebug() << "Kvaser driver not installed (canlib32.dll not found)";
        return false;
    }

    kvaser.canInitializeLibrary();

    int channelCount = 0;
    kvaser.canGetNumberOfChannels(&channelCount);
    if (channelCount <= 0) {
        coreDebug() << "No Kvaser CAN channels found";
        FreeLibrary(kvaser.dll);
        kvaser.dll = nullptr;
        return false;
    }

    coreDebug() << "Found" << channelCount << "Kvaser CAN channel(s)";

    kvaserHandle_ = kvaser.canOpenChannel(0, canOPEN_ACCEPT_VIRTUAL);
    if (kvaserHandle_ < 0) {
        coreDebug() << "Failed to open Kvaser CAN channel 0";
        FreeLibrary(kvaser.dll);
        kvaser.dll = nullptr;
        return false;
    }

    long canBITRATE;
    switch (bdr) {
    case 1000:
        coreDebug() << "CAN Baudrate:" << bdr << "kbps";
        canBITRATE = canBITRATE_1M;
        break;
    case 500:
        coreDebug() << "CAN Baudrate:" << bdr << "kbps";
        canBITRATE = canBITRATE_500K;
        break;
    case 250:
        coreDebug() << "CAN Baudrate:" << bdr << "kbps";
        canBITRATE = canBITRATE_250K;
        break;
    case 125:
        coreDebug() << "CAN Baudrate:" << bdr << "kbps";
        canBITRATE = canBITRATE_125K;
        break;
    default:
        coreDebug() << "CAN Baudrate in config file is not valid, set to 500K";
        canBITRATE = canBITRATE_500K;
    }

    int stat = kvaser.canSetBusParams(kvaserHandle_, canBITRATE, 0, 0, 0, 0, 0);
    if (stat != canOK) {
        coreDebug() << "Failed to set Kvaser bus params";
        kvaser.canClose(kvaserHandle_);
        FreeLibrary(kvaser.dll);
        kvaser.dll = nullptr;
        return false;
    }

    stat = kvaser.canBusOn(kvaserHandle_);
    if (stat != canOK) {
        coreDebug() << "Failed to go bus-on";
        kvaser.canClose(kvaserHandle_);
        FreeLibrary(kvaser.dll);
        kvaser.dll = nullptr;
        return false;
    }

    kvaserDll_ = kvaser.dll;

    // Open an active peer on channel 1 so writes on channel 0 always have an
    // ACK endpoint on the bus, even when no external tool (CANking, etc.) is
    // connected. The peer needs to be *actively reading* for canlib to ACK
    // frames reliably — passive bus-on alone leaves the first ~5–10 writes
    // failing with canERR_TIMEOUT. Best-effort: if there's no second channel
    // or the peer open fails, keep going; writes may then time out when
    // nothing else is on the bus.
    if (channelCount >= 2) {
        int peer = kvaser.canOpenChannel(1, canOPEN_ACCEPT_VIRTUAL);
        if (peer >= 0) {
            int peerStat = kvaser.canSetBusParams(peer, canBITRATE, 0, 0, 0, 0, 0);
            if (peerStat == canOK) peerStat = kvaser.canBusOn(peer);
            if (peerStat == canOK) {
                kvaserPeerHandle_ = peer;
                kvaserPeerStop_ = false;
                kvaserPeerThread_ = new core::Thread();
                kvaserPeerThread_->started.connect([this]() {
                    while (!kvaserPeerStop_) {
                        long id = 0; unsigned int dlc = 0, flag = 0;
                        unsigned long t = 0;
                        unsigned char buf[8];
                        kvaser.canReadWait(kvaserPeerHandle_, &id, buf, &dlc, &flag, &t, 100);
                    }
                });
                kvaserPeerThread_->start();
                // Give the peer reader a beat to enter its canReadWait loop —
                // without this, the first few writes can fire before the peer
                // is actively reading, and time out (canERR_TIMEOUT).
                Sleep(100);
            } else {
                kvaser.canClose(peer);
            }
        }
    }

    return true;
}
#endif

void CanManager::process()
{
while(true)
{
    this->read_frame();
}
#if 0
    QTimer::singleShot(0,this,SLOT(process()));
#endif
}

bool CanManager::parse_frame(struct can_frame * frame)
{
    bool status = false;

          if(CanRxMsg::isKeepAliveMsg(frame->can_id))
          {
             resetConnectionTimeoutSignal.fire();
          }

          CanRxMsg * curr = CanRxMsg::getMsgByCanId(frame->can_id);

          if(nullptr != curr)
          {


              status = true;
              curr->process(frame);
              curr->ack(this);
              itsDisplay->forceUpdate();
#if 0
              coreDebug() << "message" << (void*)(uint32_t) frame->can_id <<"processed ts:" << core::ElapsedTimer::currentMSecsSinceEpoch();
#endif
          }

        return status;
}
