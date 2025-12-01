#include "updatecanprotocol.h"
#include <stdio.h>
#include <string.h>
#include "crc32.h"
#include "caninterface.h"
#include "mainprocessupdate.h"
#include "utils.h"

#ifdef DROP_DEBUG
unsigned char DDCANPacketType = 0;
unsigned char DDCANSequenceNumber = 0;
unsigned int  DDCANPacketLen = 0;
#endif

namespace CANProtocol {

////
/// \brief FormCANPacket - forming a sequence of physical CAN packet data for a logical packet
/// \param _command - command or acknowledge type, for logical packet header
/// \param _payload - logical packet data
/// \param _len - logical packet data length
/// \param _buffer - buffer to use for forming the sequence of physical CAN packets
/// \return
///
unsigned int FormCANPacket(unsigned char _command, unsigned char* _payload, uint16_t _len, unsigned char* _buffer)
{
    if (((_len>0) && (!_buffer)) || (_len > MAX_LOGICAL_PACKET))
    {
        LOG("Invalid packet data\n");
        return 0;
    }

    // calculating the length of physical CAN packets
    unsigned int final_len = 0;
    if (0 == _len)
    {   // if command/ackowledge has no data it occupies one 8-byte physical CAN packet
        final_len = sizeof(CAN_RAW_PACKET);
    } else
    {   // if there are payload data we need one physical CAN pakcet for each 7 payload bytes, extra packet for payload remainder, which is smaller that 7 bytes
        // and one 8-byte CAN packet for header
        final_len = ((_len / (CAN_PAYLOAD_MAX_LEN-1))) * sizeof (CAN_RAW_PACKET) + (((_len % 7)>0) ? ((_len % 7) + 1) : 0) +
                sizeof(CAN_RAW_PACKET);
    }

    if (0) LOG("New packet %u -> %u\n", _len, final_len);

    uint32_t crc32;
    crc32reset(crc32);

    CAN_RAW_PACKET* raw0 = (CAN_RAW_PACKET*)_buffer; ///< points to 1st physical CAN packet memory
    CAN_RAW_PACKET* raw = raw0+1; ///< point for 2nd physical CAN packet memory where logical packet payload is stored

    raw0->seq_no = 0; ///< filling in header
    raw0->variable.header.len = final_len;
    raw0->variable.header.type = _command;
    raw0->variable.header.crc32 = 0;

    uint8_t num = 1;
    unsigned int l=0;

    if (_payload)
    {   // forming 2nd and mote physical CAN packet from logical packet payload
        unsigned char* ofs = _payload;

        while (_len>0)
        {   // each 7 bytes from paylod are copied to new physical CAN packet
            l = (_len < (CAN_PAYLOAD_MAX_LEN-1)) ? _len : (CAN_PAYLOAD_MAX_LEN-1);
            raw->seq_no = num;
            memcpy(raw->variable.payload, ofs, l);
            num++;
            _len -= l; ofs +=l;
            raw++;
        }
    }

    // calculating CRC32 for packet
    crc32buf(crc32, (char*)raw0, final_len);
    raw0->variable.header.crc32 = crc32result(crc32);

    return final_len; ///< the CAN packet sequence is placed into _buffer
}

///
/// \brief ExtractCANData
/// \param _command placeholder for packet command
/// \param _payload buffer for raw packet data
/// \param _len length of packet payload, if logical packet has only command, _len is 0
/// \param _CANBuffer CAN data
/// \return -1 on empty packet, 0 on command only, or payload length
///
int ExtractCANData(unsigned char& _command, unsigned char* _payload, uint16_t _len, unsigned char* _CANBuffer)
{
    if ((!_CANBuffer))
    {
        LOG("Invalid CAN packet data");
        return -1;
    }

    CAN_RAW_PACKET* raw0 = (CAN_RAW_PACKET*)_CANBuffer;
    _command = raw0->variable.header.type;

    if (0 == _len)
        return 0;

    unsigned int l=0;
    unsigned char* ofs = _payload;
    _len -= sizeof(CAN_RAW_PACKET);

    if (_payload)
    {
        raw0++;

        while (_len>0)
        {
            l = (_len < CAN_PAYLOAD_MAX_LEN) ? (_len-1) : (CAN_PAYLOAD_MAX_LEN-1);
            memcpy(ofs, raw0->variable.payload, l);
            _len -= (l+1);
            ofs += l;
            raw0++;
        }
    }

    return ofs-_payload;
}

// write the logical packet
// returns 0 on error

int WriteLogicalCANPacket(unsigned char* _data, unsigned int _len, CANInterface* _cm)
{
    if (0) LOG("len: %u\n", _len);

    struct can_frame frame;
    unsigned char* ofs = _data;

    if ((_len > 0) && (nullptr == _data))
        return 0;

#ifdef DROP_DEBUG
    CANProtocol::CAN_RAW_PACKET* rp = (CANProtocol::CAN_RAW_PACKET*)_data;
    DDCANPacketType = rp->variable.header.type;
    DDCANPacketLen = _len;
#endif

    frame.can_id = CANProtocol::UpdateCANPacketID;

    while(_len > 0)
    {
        unsigned _dataLen = (_len < CAN_PAYLOAD_MAX_LEN) ? _len : CAN_PAYLOAD_MAX_LEN;

        frame.can_dlc = 8;
        memcpy(&(frame.data[0]), ofs, _dataLen);
        ofs += _dataLen;
        _len -= _dataLen;

#ifdef DROP_DEBUG
        CANProtocol::CAN_RAW_PACKET* rp = (CANProtocol::CAN_RAW_PACKET*)ofs;
        DDCANSequenceNumber = rp->seq_no;
#endif

        // write can packet to external code
        _cm->WriteFrameLowerPri(&frame);
        // select can bandwidth in percents of available CAN bus bandwidth (for 500000 baud rate)
        // this is required for allocating CAN bus bandwidth for other application (canquick)
        // if there is no CAN_BANDWIDTH_XX_PERCENT_LIMIT the app uses CAN bus for 100%
        if (_len>0)
        {
#if defined(CAN_BANDWIDTH_50_PERCENT_LIMIT)
            usleep(500);
#elif defined(CAN_BANDWIDTH_40_PERCENT_LIMIT)
            usleep(600);
#elif defined(CAN_BANDWIDTH_25_PERCENT_LIMIT)
            usleep(1000);
#elif defined(CAN_BANDWIDTH_10_PERCENT_LIMIT)
            usleep(5000);
#endif
        }

    }

    return ofs-_data;
}

} // namespace
