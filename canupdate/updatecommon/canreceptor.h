#pragma once

#ifndef CANRECEPTOR_H
#define CANRECEPTOR_H

#include <stdint.h>

class CANReceptor {

public:
    virtual int CANPacketReceptor(unsigned char*, uint32_t) = 0;
};

#endif // CANRECEPTOR_H
