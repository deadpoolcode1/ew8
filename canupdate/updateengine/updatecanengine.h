#pragma once

#ifndef UPDATECANPARSER_H
#define UPDATECANPARSER_H

#include <stdint.h>

#include "updatecommon/updatecanprotocol.h"
#include "updatecanprocessor.h"
#include "updatecommon/caninterface.h"
#include "updatecommon/canreceptor.h"

#include <chrono>

class CANUpdateEngine: public CANReceptor
{

public:
    enum class CANIncomingFlag {
        CAN_OK,
        CAN_ERR,
    };

    enum class CANIncomingType {
        CAN_COMMAND,
        CAN_DATA
    };

    enum class CANStatus {
        CAN_STATUS_OK = 0,
        CAN_STATUS_PARAM_ERR    = 100,
        CAN_STATUS_COMMAND_ERR  = 101,
        CAN_STATUS_DATA_ERR     = 102,
        CAN_STATUS_MEM_ERR      = 103,
    };

    // internal data
    enum class CommunicationInputState {
        READY, // ready for a new command
        TRANSPORT,
    };

    static const uint32_t MAX_OUT_BUFFER = 512;

    CommunicationInputState m_inputState;
    unsigned char* m_oBuffer[64];
    CANProcessor* m_CANProcessor;
    CANInterface* m_canInterface;

    std::chrono::time_point<std::chrono::system_clock> m_timeoutTimer;

    ///////////////////////////////////
    /// re-seq packets data structures
    unsigned int m_seqStored;
    unsigned char m_seqBuffer[CAN_MAX_SEQUENCE*CAN_PAYLOAD_MAX_LEN];
    unsigned char m_fillSeqBuffer[CAN_MAX_SEQUENCE];
    unsigned int m_seqMax;
    unsigned int m_seqLen;
    uint32_t m_seqCrc32;
    unsigned char m_seqComm;
    unsigned char m_payloadBuffer[CAN_MAX_SEQUENCE*CAN_PAYLOAD_MAX_LEN];

    unsigned char m_outBuffer[CAN_MAX_SEQUENCE*CAN_PAYLOAD_MAX_LEN];

    void Reset();
    CANStatus DataHandler(unsigned char* _buf, unsigned int _len);
    CANStatus AckHandler( CANProtocol::CAN_ACKNOWLEDGES _ack, unsigned char* _buffer);
    CANStatus WriteAck(unsigned char _ack, uint32_t len, unsigned char* buf);
    CANStatus CommandHandler( CANProtocol::CAN_COMMANDS _command, unsigned char* _buffer);
    CANStatus IncomingCommandData(unsigned char* _bytes, unsigned int _length, CANUpdateEngine::CANIncomingFlag _flag);
    CANStatus AckResend();
    CANStatus ResetLogic();

    CANUpdateEngine(CANInterface* _cm);
    void Launch();
    ~CANUpdateEngine();

    int CANPacketReceptor(unsigned char *_data, uint32_t _size);

}; // structure


#endif // UPDATECANPARSER_H
