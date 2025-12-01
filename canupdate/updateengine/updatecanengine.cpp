#include "updatecanengine.h"
#include "updatecommon/caninterface.h"
#include "updatecommon/crc32.h"

CANUpdateEngine::CANUpdateEngine(CANInterface* _cm)
{
   m_canInterface = _cm;

   Reset();
}

void CANUpdateEngine::Launch()
{
    ControlFile* cf = new ControlFile();
    m_CANProcessor = new CANProcessor(cf);

    cf->BootStrap();

    m_CANProcessor->PowerOn();

    if (0) m_canInterface->SetDropTest(true);
}

CANUpdateEngine::~CANUpdateEngine()
{
    delete m_CANProcessor->m_controlFile;
    delete m_CANProcessor;
}

int CANUpdateEngine::CANPacketReceptor(unsigned char *_data, uint32_t _size)
{
    return (int)IncomingCommandData(_data, _size, CANIncomingFlag::CAN_OK);
}

void CANUpdateEngine::Reset()
{
    m_inputState = CommunicationInputState::READY;
}

///
/// \brief CAN_incoming_parser::DataHandler - handling incoming chunk of data - write it to file
/// \param _buf
/// \param _len
/// \return
///
CANUpdateEngine::CANStatus CANUpdateEngine::DataHandler(unsigned char* _buf, unsigned int _len)
{
    if (0) LOG("len: %u\n", _len);

    CANProcessor::CANProcessorStatus dErr = m_CANProcessor->DownloadedData(_buf, _len);

    return (CANProcessor::CANProcessorStatus::OK != dErr) ? CANStatus::CAN_STATUS_DATA_ERR : CANStatus::CAN_STATUS_OK;
}

///
/// \brief CANUpdateParser::WriteAck
/// \param _ack acknowledge number
/// \param _len additional data length (may be 0)
/// \param _buf buffer for additional data (may be 0)
/// \return
///
CANUpdateEngine::CANStatus CANUpdateEngine::WriteAck(unsigned char _ack, uint32_t _len, unsigned char* _buf)
{
    uint32_t canLen = 0;

    canLen = CANProtocol::FormCANPacket(_ack, _buf, _len, m_outBuffer);

    int len = CANProtocol::WriteLogicalCANPacket(m_outBuffer, canLen, m_canInterface);
    return (0 == len) ? CANUpdateEngine::CANStatus::CAN_STATUS_COMMAND_ERR : CANUpdateEngine::CANStatus::CAN_STATUS_OK;
}
///
/// \brief CAN_incoming_parser::AckHandler form acknowledge CAN packet
/// \param _ack
/// \param _buffer the first byte is reserved for command
/// \return
///
CANUpdateEngine::CANStatus CANUpdateEngine::AckHandler(CANProtocol::CAN_ACKNOWLEDGES _ack, unsigned char* _buffer)
{
    unsigned int len = 0;

    if (0) LOG("ack: %u\n", (unsigned)_ack);
    if (!_buffer)  _buffer = (unsigned char*)m_oBuffer;

    switch (_ack) {
       case  CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_WITH_VER:
           len = strlen((const char*)_buffer+sizeof(unsigned char))+1; // final zero guaranteed
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_DATA:
           len = sizeof (CANProtocol::CAN_ACKNOWLEDGE::variable::Ack_Data);
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK:
           len = sizeof (CANProtocol::CAN_ACKNOWLEDGE::variable::Ack_Chunk);
        break;
       case CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_UPDATE_STATUS:
            len = sizeof (CANProtocol::CAN_ACKNOWLEDGE::variable::Ack_UpdateStatus);
        break;
       default:
            len = 0;
    }

    return WriteAck((unsigned char)_ack, len, _buffer + sizeof(unsigned char));
}

///
/// \brief CommandHandler - main switch :) where command are parsed
/// \param _command command to process
/// \param _buffer guaranteed command parameters
/// \return
///
CANUpdateEngine::CANStatus CANUpdateEngine::CommandHandler(CANProtocol::CAN_COMMANDS _command, unsigned char* _buffer)
{
    CANProcessor::CANProcessorStatus pst;
    CANUpdateEngine::CANStatus stat;
    uint64_t size;
    uint16_t chunk_size;
    int chunk;
    CANProtocol::CAN_COMMAND* comm = (CANProtocol::CAN_COMMAND*)(_buffer - sizeof(unsigned char));
    CANProtocol::CAN_ACKNOWLEDGE* ackBuffer = (CANProtocol::CAN_ACKNOWLEDGE*)m_oBuffer;
    SHA2Store sha2st;

    if (0) LOG("command: %u\n", (unsigned(_command)));

    switch (_command) {
    case CANProtocol::CAN_COMMANDS::CAN_SET_VERSION:
        pst = m_CANProcessor->SetVersion((char*)comm->variable.CANVersion.version);
        switch (pst)
        {
        case CANProcessor::CANProcessorStatus::OK:
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
            break;
        case CANProcessor::CANProcessorStatus::DIR_EXISTS:
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_EXISTS, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
            break;
        default:
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_PARAM, nullptr);
            stat = CANStatus::CAN_STATUS_PARAM_ERR;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_SET_INFO:
        size = comm->variable.CANSetInfo.fileSize;
        chunk_size = (uint32_t)comm->variable.CANSetInfo.chunkSize;

        pst = m_CANProcessor->SetInfo(size, chunk_size);
        if (CANProcessor::CANProcessorStatus::OK == pst)
        {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
        }
        else
        {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_PARAM, nullptr);
            stat = CANStatus::CAN_STATUS_PARAM_ERR;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_GET_NUM_WR_CH:
        if (m_CANProcessor)
        {
            pst = m_CANProcessor->GetNextChunk(chunk);
            if (CANProcessor::CANProcessorStatus::NEED_VERSION == pst)
            {
                AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_VER, nullptr);
                stat = CANStatus::CAN_STATUS_PARAM_ERR;
            } else
            {
                ackBuffer->variable.Ack_Chunk.chunk = chunk;
                AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK, (unsigned char*)ackBuffer);
                stat = CANStatus::CAN_STATUS_OK;
            }
        }
        else
        {    LOG("Non initialized processor\n");
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_WRITE_CH:
        size = comm->variable.CANWrite._size ;
        if (!m_CANProcessor->CheckChunkSize(size))
        {
            LOG("INCORRECT CHUNK SIZE\n");
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_COM, nullptr);
            stat = CANStatus::CAN_STATUS_PARAM_ERR;
        }
        else
        {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_CHECK_SIGN:
        chunk = comm->variable.CANCheckSign.chunk;
        pst =  m_CANProcessor->CheckChunkSHA2(chunk, &sha2st);
        memcpy(ackBuffer->variable.Ack_Data.SHA256, &sha2st, sizeof(SHA2Store));
        if (CANProcessor::CANProcessorStatus::OK != pst)
        {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_SIG, nullptr);
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        else {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_DATA, (unsigned char*)ackBuffer);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_USER_UPDATE:
        pst = m_CANProcessor->UpdateContent();
        if (CANProcessor::CANProcessorStatus::CONTENT_PENDING != pst)
        {   // on error
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        else {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_USER_REMOVE:
        pst = m_CANProcessor->RemoveContent((unsigned char*)_buffer);
        if (CANProcessor::CANProcessorStatus::OK != pst)
        {   // on error/lock
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_NRES, nullptr);
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        else {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_USER_GET_VER:
        pst = m_CANProcessor->GetContentVersion( (unsigned char*)(ackBuffer->variable.Ack_Version.version), 510);
        if (CANProcessor::CANProcessorStatus::OK != pst)
        {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_NRES, nullptr);
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        else {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_WITH_VER, (unsigned char*)ackBuffer);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    case CANProtocol::CAN_COMMANDS::CAN_GET_UPD_STATUS:

        stat = CANStatus::CAN_STATUS_OK;

        CANProtocol::UpdateStatus status;
        status = m_CANProcessor->GetUpdateStatus();
        ackBuffer->variable.Ack_UpdateStatus.status = (int32_t)status;
        AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_UPDATE_STATUS, (unsigned char*)ackBuffer);

        break;

    case CANProtocol::CAN_COMMANDS::CAN_FORCE_ROLLBACK:
        pst = m_CANProcessor->ForceRollBack();
        if (CANProcessor::CANProcessorStatus::CONTENT_PENDING != pst)
        {   // on error
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
            stat = CANStatus::CAN_STATUS_COMMAND_ERR;
        }
        else {
            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_OK, nullptr);
            stat = CANStatus::CAN_STATUS_OK;
        }
        break;

    default:
        AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
        stat = CANStatus::CAN_STATUS_COMMAND_ERR;
    }

    m_inputState = CommunicationInputState::READY;
    return stat;
}

CANUpdateEngine::CANStatus CANUpdateEngine::ResetLogic()
{
    memset((void*)m_fillSeqBuffer, 0, sizeof(m_fillSeqBuffer)); // zero packet flags
    m_seqStored = 0;
    m_seqMax = CAN_MAX_SEQUENCE;
    m_seqLen = 0;
    m_timeoutTimer = std::chrono::system_clock::now();
    return CANUpdateEngine::CANStatus::CAN_STATUS_OK;
}

CANUpdateEngine::CANStatus CANUpdateEngine::IncomingCommandData(unsigned char* _bytes, unsigned int _length, CANIncomingFlag _flag)
{

    if (0) LOG("Incoming %u:%u (%u)\n", (unsigned)_bytes[0], _length, (unsigned)_flag );
    CANProtocol::CAN_RAW_PACKET* raw = (CANProtocol::CAN_RAW_PACKET*) _bytes;

    if (_flag == CANIncomingFlag::CAN_ERR)
        return CANUpdateEngine::CANStatus::CAN_STATUS_DATA_ERR;

    if (m_inputState == CommunicationInputState::READY)
    {  m_inputState = CommunicationInputState::TRANSPORT;
       ResetLogic();
    }

    // check for timeout and reset
    std::chrono::duration<double> diff = std::chrono::system_clock::now() - m_timeoutTimer;
    double elapsed = diff.count();

    if (elapsed > CANProtocol::MAX_TIMEOUT)
    {
        m_inputState = CommunicationInputState::TRANSPORT;
        ResetLogic();
        LOG("Dropped CAN packet detected, logical packet restarted\n");
    }

    if (raw->seq_no >= m_seqMax)
    {
        /// error
        AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
        ResetLogic();
        LOG("Incorrect CAN packet sequence number, logical packet restarted\n");
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
                m_seqStored = m_seqMax-1;
            }
        }
        memcpy((void*)&(m_seqBuffer[raw->seq_no*CAN_PAYLOAD_MAX_LEN]), _bytes, _length);
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

                    int realLen = CANProtocol::ExtractCANData(_comm, m_payloadBuffer, m_seqLen, (unsigned char*)m_seqBuffer);

                    if (CANProtocol::CAN_SEND_DATA != _comm)
                    {   // handle as command
                        CommandHandler((CANProtocol::CAN_COMMANDS) _comm, m_payloadBuffer);
                    }
                    else
                    {   // handle as data
                        CANStatus cStat = DataHandler(m_payloadBuffer, realLen);

                        if (CANStatus::CAN_STATUS_OK == cStat)
                        {
                            CANProtocol::CAN_ACKNOWLEDGE* ackBuffer = (CANProtocol::CAN_ACKNOWLEDGE*)m_oBuffer;
                            m_CANProcessor->GetNextChunk(ackBuffer->variable.Ack_Chunk.chunk);

                            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_ACK_CHUNK, (unsigned char*)ackBuffer);
                        }
                        else
                        {
                            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
                        }
                    }
                    m_inputState = CommunicationInputState::READY;
                    ResetLogic();
                    return CANUpdateEngine::CANStatus::CAN_STATUS_OK;
                }
                LOG("Incoming logical packet CRC error, logical packet restarted\n");
            }

            AckHandler(CANProtocol::CAN_ACKNOWLEDGES::CAN_NACK_GEN, nullptr);
            m_inputState = CommunicationInputState::READY;
        }
        // whole packet was not assembled still
    }
    else
    {   LOG("Double CAN packet detected, continue\n");  }

    m_timeoutTimer = std::chrono::system_clock::now();
    return CANUpdateEngine::CANStatus::CAN_STATUS_OK;
}


