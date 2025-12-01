#include "updateapi/updatecanapi.h"
#include "updatecommon/caninterface.h"
#include "updatecommon/crc32.h"
#include "updatecommon/utils.h"

CANUpdateAPI::CANUpdateAPI(CANInterface* _cm)
{
    m_canInterface = _cm;

    m_commandInFly = OperationWaitState::NO_COMMAND;

    m_inputState = CommunicationInputState::READY;
}

CANUpdateAPI::~CANUpdateAPI()
{
}

int CANUpdateAPI::CANPacketReceptor(unsigned char *_data, uint32_t _size)
{
    return (int)IncomingData(_data, _size, CANIncomingFlag::CAN_OK);
}

void CANUpdateAPI::DropElapsedTime(int i)
{
    m_startTime[i] = std::chrono::system_clock::now();
}

double CANUpdateAPI::GetElapsedTime(int i)
{
    std::chrono::duration<double> diff = std::chrono::system_clock::now() - m_startTime[i];
    return diff.count();
}

void CANUpdateAPI::renderTimeout(CANProtocol::CAN_ACKNOWLEDGES _timeout_type, char* _message, float _timeout)
{
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == _timeout_type)
    {
        LOG("%s: timeout %.1f sec\n", _message, _timeout);
    }
}

CANProtocol::CAN_ACKNOWLEDGES CANUpdateAPI::WaitForAck(OperationWaitState _state, float _timeout)
{
    DropElapsedTime(0);
    m_arrAck[(int)_state] = CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT;

    while (m_arrAck[(int)_state] == CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT)
    {
        usleep(10000); // 10ms
        if (GetElapsedTime(0) >= _timeout)
        {
            break;
        }
    }
    return m_arrAck[(int)_state];
}

///
/// \brief UpdateAPIContext::SendPacket - send a seria of packet over CAN bus
/// \param _data - buffer ptr
/// \param _dataLen - length for DATa packets
/// \param _type - Packet id (data or command)
/// \return
///
CANUpdateAPI::UpdateContextError CANUpdateAPI::SendCommandPacket(CANProtocol::CAN_COMMANDS _comm, unsigned char* _data)
{
    uint32_t canLen = 0;
    int dataLen = 0;

        switch (_comm) {
           case CANProtocol::CAN_COMMANDS::CAN_SET_VERSION:
           case CANProtocol::CAN_COMMANDS::CAN_USER_REMOVE:
                dataLen = strlen((char*)_data)+ 1;
            break;
          case CANProtocol::CAN_COMMANDS::CAN_SET_INFO:
                dataLen = sizeof( CANProtocol::CAN_COMMAND::variable::CANSetInfo);
            break;
          case CANProtocol::CAN_COMMANDS::CAN_WRITE_CH:
                dataLen = sizeof (CANProtocol::CAN_COMMAND::variable::CANWrite);
            break;
          case CANProtocol::CAN_COMMANDS::CAN_CHECK_SIGN:
              dataLen = sizeof (CANProtocol::CAN_COMMAND::variable::CANCheckSign);
          break;
         case CANProtocol::CAN_COMMANDS::CAN_GET_UPD_STATUS:
        case CANProtocol::CAN_COMMANDS::CAN_GET_NUM_WR_CH:
        case CANProtocol::CAN_COMMANDS::CAN_USER_UPDATE:
        case CANProtocol::CAN_COMMANDS::CAN_USER_GET_VER:
          default:
              dataLen = 0;
        }

    canLen = CANProtocol::FormCANPacket((unsigned char)_comm, _data, dataLen, m_outBuffer);

    int len = CANProtocol::WriteLogicalCANPacket(m_outBuffer, canLen, m_canInterface);

    return (0 == len) ? UpdateContextError::UPDATE_CAN_SEND_ERROR : UpdateContextError::UPDATE_OK;
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::SendDataPacket(unsigned char* _data, uint16_t _len)
{
    uint32_t canLen = 0;

    canLen = CANProtocol::FormCANPacket(CANProtocol::CAN_SEND_DATA, _data, _len, m_outBuffer);

    int len = CANProtocol::WriteLogicalCANPacket(m_outBuffer, canLen, m_canInterface);

    return (0 == len) ? UpdateContextError::UPDATE_CAN_SEND_ERROR : UpdateContextError::UPDATE_OK;
}

/**
 * @brief CANUpdateAPI::InitTransfer initialize transfer
 * @param _version new version
 * @param _size
 * @param _chunk_size
 * @return
 */
CANUpdateAPI::UpdateContextError CANUpdateAPI::InitTransfer(std::string _version, uint32_t _size, uint32_t _chunk_size)
{
    CANProtocol::CAN_COMMAND* comm = (CANProtocol::CAN_COMMAND*)m_oBuffer;

    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Session is opened already\n");
        return UpdateContextError::UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY;
    }

    m_commandInFly = OperationWaitState::INIT_TRASFER;

    strncpy((char*)(comm->variable.CANVersion.version), (char*)_version.c_str(), MAX_OUT_BUFFER-1);

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_SET_VERSION, m_oBuffer+1);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::INIT_TRASFER, INIT_TRANSFER_TIMEOUT);

    renderTimeout(ack, (char*)"Init transfer", INIT_TRANSFER_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack) // no answer
    {
        m_commandInFly = OperationWaitState::NO_COMMAND;
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_EXISTS == ack) // version already exists
    {
        m_commandInFly = OperationWaitState::NO_COMMAND;
        LOG("Version %s already exists\n", _version.c_str());
        return UpdateContextError::UPDATE_OK;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack) // negative answer
    {
        m_commandInFly = OperationWaitState::NO_COMMAND;
        LOG("Error while initializing transfer\n");
        return UpdateContextError::UPDATE_CAN_PARAM_ERROR;
    }
    // follows for positive answer
    comm->variable.CANSetInfo.fileSize = _size;
    comm->variable.CANSetInfo.chunkSize = _chunk_size;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_SET_INFO, m_oBuffer+1);

    ack = WaitForAck(OperationWaitState::INIT_TRASFER, INIT_TRANSFER_TIMEOUT);
    renderTimeout(ack, (char*)"Transfer parameters setting", INIT_TRANSFER_TIMEOUT);

    m_commandInFly = OperationWaitState::NO_COMMAND;
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack)
    {
        LOG("Error while setting transfer parameters\n");
        return UpdateContextError::UPDATE_CAN_PARAM_ERROR;
    }

    m_chunkSize = _chunk_size;
    m_fileSize = _size;

    return UpdateContextError::UPDATE_OK;
}

/**
 * @brief CANUpdateAPI::GetNextChunk returns next chunks number to write
 * 0...N for regular chunks, -1 if file was written successfully, CHUNK_NUMBER_ERROR is an error was occured
 * @return
 */
int CANUpdateAPI::GetNextChunk()
{
    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return CHUNK_NUMBER_ERROR;
    }

    m_commandInFly = OperationWaitState::GET_NEXT_CHUNK;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_GET_NUM_WR_CH, nullptr);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::GET_NEXT_CHUNK, GET_NEXT_CHUNK_TIMEOUT);

    m_commandInFly = OperationWaitState::NO_COMMAND;
    renderTimeout(ack, (char*)"Get next chunk number", GET_NEXT_CHUNK_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK != ack)
    {
        LOG("Error getting acknowledge for next transferred chunk number\n");
        return CHUNK_NUMBER_ERROR;
    }

    return m_intBuffer;
}

///
/// \brief UpdateAPIContext::DataLoop
/// \param _buffer
/// \param _len
/// \return  number of sent bytes on success
///          CHUNK_NUMBER_ERROR in case of timeour or ther error
///
///
int CANUpdateAPI::DataLoop(unsigned char* _buffer, unsigned int _len)
{
    m_arrAck[(int)OperationWaitState::PUSH_CHUNK] = CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT;

    DropElapsedTime(0);

    SendDataPacket(_buffer, _len);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::PUSH_CHUNK, PUSH_CHUNK_TIMEOUT);

    renderTimeout(ack, (char*)"Data packet transmission", PUSH_CHUNK_TIMEOUT);

    return (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK != ack) ? CHUNK_NUMBER_ERROR : (int)_len;
}

/**
 * @brief CANUpdateAPI::PushChunk send chunk to another side
 * @param _chunk chunk number
 * @param _description data address
 * @param _size size of data
 * @return next chunk number or CHUNK_NUMBER_ERROR
 */
int CANUpdateAPI::PushChunk(int _chunk, char* _description, uint16_t _size)
{
    (void)_chunk;
    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return CHUNK_NUMBER_ERROR;
    }

    m_commandInFly = OperationWaitState::PUSH_CHUNK;

    CANProtocol::CAN_COMMAND* comm = (CANProtocol::CAN_COMMAND*)m_oBuffer;

    comm->variable.CANWrite._size = _size;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_WRITE_CH, m_oBuffer+1);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::PUSH_CHUNK, PUSH_CHUNK_TIMEOUT);

    renderTimeout(ack, (char*)"Initiation of data packet transmission", PUSH_CHUNK_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack)
    {
        LOG("Error while sending chunk to another side\n");
        m_commandInFly = OperationWaitState::NO_COMMAND;
        return CHUNK_NUMBER_ERROR;
    }

    int status = DataLoop((unsigned char*)_description, _size);

    m_commandInFly = OperationWaitState::NO_COMMAND;

    if (CHUNK_NUMBER_ERROR == status)
        return status;

    return m_intBuffer; //GetNextChunk();
}

/**
 * @brief CANUpdateAPI::VerifyContent verify loaded content
 * @param _sum placeholder for SHA256 sum
 * @return
 */
CANUpdateAPI::UpdateContextError CANUpdateAPI::VerifyContent(SHA2Store& _sum)
{
    CANProtocol::CAN_COMMAND* comm = (CANProtocol::CAN_COMMAND*)m_oBuffer;

    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return UpdateContextError::UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY;
    }

    m_commandInFly = OperationWaitState::VERIFY;

    comm->variable.CANCheckSign.chunk = -1;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_CHECK_SIGN, m_oBuffer+1);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::VERIFY, VERIFY_TIMEOUT);

    renderTimeout(ack, (char*)"Data verification", VERIFY_TIMEOUT);
    m_commandInFly = OperationWaitState::NO_COMMAND;
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_SIG == ack)
    {
        LOG("Verification error at another side\n");
        return UpdateContextError::UPDATE_VERIFICATION_ERROR;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_DATA != ack)
    {
        LOG("Verification error at other side\n");
        return UpdateContextError::UPDATE_VERIFICATION_ERROR;
    }
    else
    {
        _sum = m_sha256Buffer;
        return UpdateContextError::UPDATE_OK;
    }
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::UpdateContent()
{
    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return UpdateContextError::UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY;
    }

    m_commandInFly = OperationWaitState::UPDATE_COMMAND;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_USER_UPDATE, nullptr);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::UPDATE_COMMAND, UPDATE_COMMAND_TIMEOUT);

    m_commandInFly = OperationWaitState::NO_COMMAND;
    renderTimeout(ack, (char*)"Update initiation", UPDATE_COMMAND_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack)
    {
        LOG("Update error while starting update execution\n");
        return UpdateContextError::UPDATE_ERROR;
    }
    else
    {
        return UpdateContextError::UPDATE_OK;
    }
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::DiscardContent(std::string& _version, bool _force_rollback)
{
    CANProtocol::CAN_COMMAND* comm = (CANProtocol::CAN_COMMAND*)m_oBuffer;

    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return UpdateContextError::UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY;
    }

    UpdateContextError rollStatus = UpdateContextError::UPDATE_OK;

    if (_force_rollback)
    {
        m_commandInFly = OperationWaitState::UPDATE_COMMAND;

        SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_FORCE_ROLLBACK, nullptr);

        CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::UPDATE_COMMAND, UPDATE_COMMAND_TIMEOUT);
        m_commandInFly = OperationWaitState::NO_COMMAND;

        renderTimeout(ack, (char*)"Force rollback timeout", UPDATE_COMMAND_TIMEOUT);
        if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
        {
             rollStatus = UpdateContextError::UPDATE_TIMEOUT;
        }
        if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack)
        {
            LOG("Error while forcing rollback\n");
            rollStatus = UpdateContextError::UPDATE_ERROR;
        }
        else
        {
            rollStatus = UpdateContextError::UPDATE_OK;
        }
    }

    m_commandInFly = OperationWaitState::DISCARD_DATA;

    strncpy((char*)(comm->variable.CANVersion.version), (char*)_version.c_str(), MAX_OUT_BUFFER);

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_USER_REMOVE, m_oBuffer+1);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::DISCARD_DATA, DISCARD_DATA_TIMEOUT);
    m_commandInFly = OperationWaitState::NO_COMMAND;

    renderTimeout(ack, (char*)"Discard data at EW8 side", DISCARD_DATA_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK != ack)
    {
        LOG("Error while discarding content\n");
        return UpdateContextError::UPDATE_CAN_PARAM_ERROR;
    }
    else
    {
        return rollStatus;
    }
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::GetCurrentVersion(std::string& _version, CANProtocol::UpdateStatus& _status)
{
    if (OperationWaitState::NO_COMMAND != m_commandInFly)
    {
        LOG("Other command is on execution now\n");
        return UpdateContextError::UPDATE_COMMAND_IS_ON_EXECUTION_ALREADY;
    }

    m_commandInFly = OperationWaitState::GET_UPDATE_STATUS;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_USER_GET_VER, nullptr);

    CANProtocol::CAN_ACKNOWLEDGES ack = WaitForAck(OperationWaitState::GET_UPDATE_STATUS, GET_UPDATE_STATUS_TIMEOUT);

    m_commandInFly = OperationWaitState::NO_COMMAND;
    renderTimeout(ack, (char*)"Getting update process status", GET_UPDATE_STATUS_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_WITH_VER != ack)
    {
        LOG("Negative acknowledge for version request\n");
        return UpdateContextError::UPDATE_ERROR;
    }
    else
    {
        _version = std::string((char*)m_oStringBuffer);
    }

    m_commandInFly = OperationWaitState::GET_UPDATE_STATUS;

    SendCommandPacket(CANProtocol::CAN_COMMANDS::CAN_GET_UPD_STATUS, nullptr);

    ack = WaitForAck(OperationWaitState::GET_UPDATE_STATUS, GET_UPDATE_STATUS_TIMEOUT);

    m_commandInFly = OperationWaitState::NO_COMMAND;
    renderTimeout(ack, (char*)"Get update status", GET_UPDATE_STATUS_TIMEOUT);
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_TIMEOUT == ack)
    {
        return UpdateContextError::UPDATE_TIMEOUT;
    }
    if (CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_UPDATE_STATUS != ack)
    {
        LOG("Error while getting update status\n");
        return UpdateContextError::UPDATE_ERROR;
    }
    else
    {
        _status = (CANProtocol::UpdateStatus)m_updateStatusBuffer;
        return UpdateContextError::UPDATE_OK;
    }
}

void CANUpdateAPI::renderAck(CANProtocol::CAN_ACKNOWLEDGES _ack)
{
    char* message = NULL;
    switch (_ack)
    {
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_COM: message = (char*)CANProtocol::AckDescNACK_COM;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN: message = (char*)CANProtocol::AckDescNACK_GEN;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_NRES: message = (char*)CANProtocol::AckDescNACK_RES;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_PARAM: message = (char*)CANProtocol::AckDescNACK_PARAM;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_SIG: message = (char*)CANProtocol::AckDescNACK_SIG;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_VER: message = (char*)CANProtocol::AckDescNACK_VER;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_EXISTS: message = (char*)CANProtocol::AckDescACK_EXISTS;
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_WITH_VER: message = (char*)CANProtocol::AckDescACK_WITH_VER;
        break;
       default: ;
    }
    if (message)
    {
        LOG("Acknowledge received: %s\n", message);
    }
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::AckHandler(CANProtocol::CAN_ACKNOWLEDGES _ack, unsigned char* _buffer)
{
    SHA2Store sha2st;
    CANProtocol::CAN_ACKNOWLEDGE* ackBuffer = (CANProtocol::CAN_ACKNOWLEDGE*)(_buffer-sizeof(unsigned char));

    switch (_ack) {
    case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_WITH_VER:
        strncpy((char*)m_oStringBuffer, (char*)ackBuffer->variable.Ack_Version.version, MAX_OUT_BUFFER );
        break;
    case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK:
        m_intBuffer = ackBuffer->variable.Ack_Chunk.chunk;
        break;
    case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_DATA:
        m_intBuffer = ackBuffer->variable.Ack_Data.chunk;
        memcpy( (char*)m_sha256Buffer.bytes, (char*)ackBuffer->variable.Ack_Data.SHA256, sizeof(SHA2Store));
        break;
    case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_UPDATE_STATUS:
        m_updateStatusBuffer = ackBuffer->variable.Ack_UpdateStatus.status;
        break;
    default: ;
        break;
    }

    renderAck(_ack);
    m_arrAck[(unsigned int)m_commandInFly] = _ack;

    return UpdateContextError::UPDATE_OK;
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::ResetLogic()
{
    memset((void*)m_fillSeqBuffer, 0, sizeof(m_fillSeqBuffer)); // zero packet flags
    m_seqStored = 0;
    m_seqMax = CAN_MAX_SEQUENCE;
    m_seqLen = 0;
    m_timeoutTimer = std::chrono::system_clock::now();
    return UpdateContextError::UPDATE_OK;
}

CANUpdateAPI::UpdateContextError CANUpdateAPI::IncomingData(unsigned char* _bytes, unsigned int _length, CANIncomingFlag _flag)
{
    if (0) LOG("Incoming %u:%u (%u)\n", (unsigned)_bytes[0], _length, (unsigned)_flag );
    CANProtocol::CAN_RAW_PACKET* raw = (CANProtocol::CAN_RAW_PACKET*) _bytes;

    if (_flag == CANIncomingFlag::CAN_ERR)
        return UpdateContextError::UPDATE_CAN_RECEIVE_ERROR;

    if (m_inputState == CommunicationInputState::READY)
    {   m_inputState = CommunicationInputState::CMD;
        ResetLogic();
    }

    // check for timeout and reset
    std::chrono::duration<double> diff = std::chrono::system_clock::now() - m_timeoutTimer;
    double elapsed = diff.count();

    if (elapsed > CANProtocol::MAX_TIMEOUT)
    {
        m_inputState = CommunicationInputState::READY;
        ResetLogic();
        LOG("Timeout 1.0s while receiveing pakcet\n");
        // return UpdateContextError::UPDATE_TIMEOUT;
    }

    if (raw->seq_no >= m_seqMax)
    {
        ResetLogic();
        LOG("Inconsistent physical packet number\n");
        return UpdateContextError::UPDATE_CAN_SEND_ERROR;
    }

    if (0 == m_fillSeqBuffer[raw->seq_no])
    {   // fill in the part
        if (0 == raw->seq_no)
        {
            m_seqLen = raw->variable.header.len;
            m_seqMax = (raw->variable.header.len + (CAN_PAYLOAD_MAX_LEN-1)) / CAN_PAYLOAD_MAX_LEN;
            m_seqCrc32 = raw->variable.header.crc32;
            m_seqComm = raw->variable.header.type;
            if (m_seqStored >= m_seqMax)
            {
                m_seqStored = 0; // m_seqMax-1;
            }
        }
        memcpy((void*)m_seqBuffer[raw->seq_no], _bytes, _length);
        m_fillSeqBuffer[raw->seq_no] = 1;
        m_seqStored++;

        if (m_seqStored == m_seqMax) // got all packets
        {
            uint32_t partLen = 0;
            for(unsigned int u=0; u<m_seqMax;u++)
            {
                partLen += m_fillSeqBuffer[u];
            }

            if( m_seqMax == partLen)
            { // length OK
                CANProtocol::CAN_RAW_PACKET* raw0 = (CANProtocol::CAN_RAW_PACKET*) m_seqBuffer;
                uint32_t crc32;
                crc32reset(crc32);

                raw0->variable.header.crc32 = 0;

                crc32buf(crc32, (char*)raw0, m_seqLen);

                if (crc32result(crc32) == m_seqCrc32)
                {   // even good CRC
                    unsigned char _comm;

                    CANProtocol::ExtractCANData(_comm, m_payloadBuffer, m_seqLen, (unsigned char*)m_seqBuffer);
                    if (CANProtocol::CAN_SEND_DATA != _comm)
                    {   // handle as command
                        AckHandler((CANProtocol::CAN_ACKNOWLEDGES) _comm, m_payloadBuffer);
                    }
                    m_inputState = CommunicationInputState::READY;
                    return UpdateContextError::UPDATE_OK;
                }
            }
            m_inputState = CommunicationInputState::READY;
        }
    } else
    {
        return UpdateContextError::UPDATE_OK;
    }

    m_timeoutTimer = std::chrono::system_clock::now();
    return UpdateContextError::UPDATE_OK;
}
