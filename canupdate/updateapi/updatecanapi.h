#pragma once

#ifndef CANUPDATEAPI_H
#define CANUPDATEAPI_H

#include "updatecommon/updatecanprotocol.h"
#include <chrono>

#include <ctype.h>
#include <stdint.h>
#include <cstring>
#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include "updatecommon/caninterface.h"
#include "updatecommon/canreceptor.h"

const unsigned int MAX_CAN_COMMAND = 520;
const int SUCCESS = 0;

const int CHUNK_NUMBER_ERROR = -2;
const int ALL_CHUNKS_ARE_DONE = -1;

class CANUpdateAPI : public CANReceptor
{
public:
    enum class UpdateContextError : unsigned int {
        UPDATE_OK = 0,
        UPDATE_CAN_SEND_ERROR = 1,
        UPDATE_CAN_PARAM_ERROR = 2,
        UPDATE_CAN_RECEIVE_ERROR = 3,
        UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY = 4,
        UPDATE_TIMEOUT = 5,
        UPDATE_VERIFICATION_ERROR =6,
        UPDATE_ERROR =6,
    };

    enum class CANIncomingFlag {
        CAN_OK,
        CAN_ERR,
    };

    enum class CANIncomingType {
        CAN_COMMAND,
        CAN_DATA
    };

    enum class CommunicationInputState {
        READY, // ready for a new command
        CMD,
    };

    // command in fly
    enum class OperationWaitState : int {
        NO_COMMAND = 0,
        INIT_TRASFER = 1,
        GET_NEXT_CHUNK = 2,
        PUSH_CHUNK = 3,
        VERIFY = 4,
        UPDATE_COMMAND = 5,
        DISCARD_DATA = 6,
        GET_UPDATE_STATUS = 7,

    };

    const float INIT_TRANSFER_TIMEOUT = 3.0;
    const float GET_NEXT_CHUNK_TIMEOUT = 1.0;
    const float PUSH_CHUNK_TIMEOUT = 3.0;
    const float VERIFY_TIMEOUT = 30.0;
    const float UPDATE_COMMAND_TIMEOUT = 3.0;
    const float DISCARD_DATA_TIMEOUT = 5.0;
    const float GET_UPDATE_STATUS_TIMEOUT = 3.0;

    // API Group
    UpdateContextError InitTransfer(std::string _version, uint32_t _size, uint32_t _chunk_size);
    int GetNextChunk();
    int PushChunk(int _chunk, char* _description, uint16_t _size);
    UpdateContextError VerifyContent(SHA2Store &);
    UpdateContextError UpdateContent();
    UpdateContextError DiscardContent(std::string& _version, bool _force_rollback);
    UpdateContextError GetCurrentVersion(std::string& _version, CANProtocol::UpdateStatus& _status);

private:
    static const unsigned int WT_STATE_MAX = 8;
    CANProtocol::CAN_ACKNOWLEDGES m_arrAck[WT_STATE_MAX];
    OperationWaitState m_commandInFly;

    static const int MAX_OUT_BUFFER = 512; ///< maximum buffer size for acknowledges

    unsigned char  m_oBuffer[MAX_OUT_BUFFER];
    unsigned char m_oStringBuffer[MAX_OUT_BUFFER];
    int m_intBuffer;
    uint32_t m_offsetBuffer;
    SHA2Store m_sha256Buffer;
    int m_updateStatusBuffer;

    std::chrono::time_point<std::chrono::system_clock> m_startTime[2];

    CommunicationInputState m_inputState;

    CANProtocol::CAN_ACKNOWLEDGES m_newAck;
    CANProtocol::CAN_COMMANDS m_currentCommand;

    CANInterface* m_canInterface;

    std::string m_version;
    unsigned char m_buffer[MAX_CAN_COMMAND];
    unsigned long m_fileSize;
    unsigned m_chunkSize;

    pthread_t m_ithread;
    int m_threadStatus;
    int m_joinStatus;

    std::chrono::time_point<std::chrono::system_clock> m_timeoutTimer;

    ///////////////////////////////////
    /// re-seq packets data structures
    unsigned int m_seqStored;
    unsigned char m_seqBuffer[CAN_MAX_SEQUENCE][CAN_PAYLOAD_MAX_LEN];
    unsigned char m_fillSeqBuffer[CAN_MAX_SEQUENCE];
    unsigned int m_seqMax;
    unsigned int m_seqLen;
    uint32_t m_seqCrc32;
    unsigned char m_seqComm;
    unsigned char m_payloadBuffer[CAN_MAX_SEQUENCE*CAN_PAYLOAD_MAX_LEN];
    unsigned char m_outBuffer[CAN_MAX_SEQUENCE*CAN_PAYLOAD_MAX_LEN];

private:
    UpdateContextError SendCommandPacket(CANProtocol::CAN_COMMANDS _comm, unsigned char* _data);
    UpdateContextError SendDataPacket(unsigned char* _data, uint16_t _len);
    UpdateContextError IncomingData(unsigned char* _bytes, unsigned int _length, CANIncomingFlag _flag);
    UpdateContextError AckHandler(CANProtocol::CAN_ACKNOWLEDGES _ack, unsigned char* _buffer);
    UpdateContextError ResetLogic();
    void renderAck(CANProtocol::CAN_ACKNOWLEDGES _ack);
    void renderTimeout(CANProtocol::CAN_ACKNOWLEDGES _timeout_type, char* _message, float _timeout);

    double GetElapsedTime(int i);
    void DropElapsedTime(int i);
    CANProtocol::CAN_ACKNOWLEDGES WaitForAck(OperationWaitState _state, float _timeout);
    int DataLoop(unsigned char* _buffer, unsigned int _len);


public:
    CANUpdateAPI(CANInterface* _cm);

    ~CANUpdateAPI();

    int CANPacketReceptor(unsigned char *_data, uint32_t _size);

    CANInterface* getCANInterface()
    {   return m_canInterface;   }
};



#endif // CANUPDATEAPI_H
