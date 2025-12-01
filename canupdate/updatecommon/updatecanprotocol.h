#pragma once

#ifndef UPDATECANPROTOCOL_H
#define UPDATECANPROTOCOL_H

#define DROP_DEBUG

#include <stdint.h>
#include "caninterface.h"

#ifndef WIN32
#include <cstring>
#endif

static const unsigned int CAN_PAYLOAD_MAX_LEN = 8;
static const unsigned int CAN_MAX_SEQUENCE = 256;

static const unsigned int MAX_LOGICAL_PACKET = (CAN_MAX_SEQUENCE-1)*(CAN_PAYLOAD_MAX_LEN-1);


#define CAN_BANDWIDTH_50_PERCENT_LIMIT
// #define CAN_BANDWIDTH_40_PERCENT_LIMIT
// #define CAN_BANDWIDTH_25_PERCENT_LIMIT
// #define CAN_BANDWIDTH_10_PERCENT_LIMIT

namespace CANProtocol {

enum class CAN_COMMANDS: unsigned char {
    CAN_NO_COMMAND      = 0,
    CAN_SET_VERSION     = 1,
    CAN_SET_INFO        = 2,
    CAN_GET_NUM_WR_CH   = 3,
    CAN_WRITE_CH        = 4,
    CAN_CHECK_SIGN      = 6,
    CAN_USER_UPDATE     = 7,
    CAN_USER_REMOVE     = 8,
    CAN_USER_GET_VER    = 9,
    CAN_GET_UPD_STATUS  = 10,
    CAN_FORCE_ROLLBACK  = 11,
};

enum class CAN_ACKNOWLEDGES: unsigned char {
    CAN_ACK_TIMEOUT       = 0,
    CAN_ACK_OK          = 0x40,
    CAN_NACK_GEN        = 0x41,
    CAN_NACK_NRES       = 0x42,
    CAN_NACK_PARAM      = 0x43,
    CAN_NACK_SIG        = 0x44,
    CAN_NACK_VER        = 0x45,
    CAN_ACK_EXISTS      = 0x46,
    CAN_ACK_WITH_VER     =0x4b, // 0-terminated string follows
    CAN_ACK_CHUNK        =0x4c, // 4 bytes follows
    CAN_KEEP_POWER       =0x4d, // keep power
    CAN_STOP_KEEP_POWER  =0x4e, // stop keeping power
    CAN_NACK_COM        = 0x50,
    CAN_ACK_DATA        = 0x51,
    CAN_ACK_UPDATE_STATUS = 0x52, // 4 bytes status
};

const unsigned char CAN_SEND_DATA = 0x80;

#pragma pack (push, 1)

struct CAN_RAW_PACKET {
    unsigned char seq_no; // sequence number
    union variable {
        unsigned char payload[CAN_PAYLOAD_MAX_LEN-1];
        struct header {
            uint16_t len;
            unsigned char type;
            uint32_t crc32;
        } header;
    } variable;
};

struct CAN_COMMAND {
    CAN_COMMANDS command;
    union variable {
        struct CANVersion {
            unsigned char version[7];
        } CANVersion;
        struct CANSetInfo {
            uint32_t fileSize;
            uint16_t chunkSize; // in bytes
        } CANSetInfo;
        struct CANWrite {
            uint16_t _size;
        } CANWrite;
        struct CANCheckSign {
            int32_t chunk;
        } CANCheckSign;
    } variable;
};

struct CAN_ACKNOWLEDGE {
    unsigned char ack; //
    union variable {
        struct Ack_Chunk {
            int32_t chunk;
        } Ack_Chunk;
        struct Ack_Data {
            int32_t chunk;
            unsigned char SHA256[32];
        } Ack_Data;
        struct Ack_Version {
            unsigned char version[7];
        } Ack_Version;
        struct Ack_UpdateStatus {
            int status;
        } Ack_UpdateStatus;
    } variable;
};

#pragma pack ( pop)

const int UpdateCANPacketID = 0x3ff;

enum class UpdateStatus: int {
    UPLOADING = 0,
    UPLOADED = 1,
    ON_EXECUTION = 2,
    DONE = 3,
    EXECUTION_ERROR = 4,
    UNKNOWN = 5,
    ROLLBACK = 6,
};

const char InternalUpdateStatusUploading[] = "uploading";
const char InternalUpdateStatusUploaded[] = "uploaded";
const char InternalUpdateStatusOnExecution[] = "executed";
const char InternalUpdateStatusError[] = "error";
const char InternalUpdateStatusDone[] = "done";
const char InternalUpdateStatusRollback[] = "rollback";

const char AckDescACK_OK[] = "ACK OK code";
const char AckDescNACK_GEN[] = "NACK: general error";
const char AckDescNACK_RES[] = "NACK: no resource at EW8 side";
const char AckDescNACK_PARAM[] = "NACK: incorrect parameters";
const char AckDescNACK_SIG[] = "NACK: signature calculation error";
const char AckDescNACK_VER[] = "NACK: corresponding version not found";
const char AckDescACK_EXISTS[] = "ACK: the update version already exists on the other side";
const char AckDescACK_WITH_VER[] = "ACK: version number returned";
const char AckDescNACK_COM[] = "NACK: the error was detected during command transmission (for example a part of command was lost)";
const char AckDescACK_DATA[] = "ACK: 32 byte SHA256 sum";
const char AckDescACK_UPDATE_STATUS[] = "ACK: 4 byte update status";


unsigned int GetAcknowledgeSize(CANProtocol::CAN_ACKNOWLEDGES _ack);
unsigned int GetCommandSize(CANProtocol::CAN_COMMANDS _comm);
unsigned int FormCANPacket(unsigned char _command, unsigned char* _payload, uint16_t _len, unsigned char* _buffer);
int ExtractCANData(unsigned char& _command, unsigned char* _payload, uint16_t _len, unsigned char* _CANBuffer);
int WriteLogicalCANPacket(unsigned char* _data, unsigned int _len, CANInterface *_cm);

static const float MAX_TIMEOUT = 1.0;

} // namespace

// store for SHA256 hash sum
struct SHA2Store
{
    unsigned char bytes[32];

    SHA2Store()

    {   memset((void*)bytes, 0, sizeof (bytes));
    }
};

struct SHASums
{
    SHA2Store *sums;

    SHASums(unsigned int _chunks)
    {
        if (_chunks > 0)
        {
            sums = new SHA2Store[_chunks] ; // new
            if (sums)
            {
                memset(sums, 0, _chunks * sizeof(SHA2Store));
            }
        }
        else { sums = nullptr;  }
    }

    ~SHASums()
    {
        delete[] sums;
    }
};

#endif // UPDATECANPROTOCOL_H
