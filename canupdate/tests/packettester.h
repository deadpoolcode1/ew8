#pragma once

#ifndef PACKETTESTER_H
#define PACKETTESTER_H

#include "../updatecommon/canreceptor.h"
#include "../updatecommon/utils.h"
#include "../updatecommon/crc32.h"

class PacketTester: public CANReceptor
{
    uint32_t m_readCounter;
    uint32_t m_errorCounter;
    uint32_t m_crcError;

public:
    PacketTester();

    int TestFrame(unsigned char* _data);

    int CANPacketReceptor(unsigned char*, uint32_t);
    ~PacketTester();
};

#endif // PACKETTESTER_H
