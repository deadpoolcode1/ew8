#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include "../updatecommon/caninterface.h"
#include "../updatecommon/canreceptor.h"
#include "../updatecommon/crc32.h"
#include "../updatecommon/utils.h"
#include "packettester.h"

class MainProcess
{
    CANInterface * m_canInterface;

    uint32_t m_counter;
public:

    MainProcess();

    void GenTraffic(int count, int _sleep);

    int LaunchEverything(int argc, char *argv[]);

    const int GEN90_PACKETS = 12;
    const int GEN90_SLEEP = 4000;

    const int GEN70_PACKETS = 9;
    const int GEN70_SLEEP = 4000;

    const int GEN50_PACKETS = 7;
    const int GEN50_SLEEP = 4000;

    const int GEN60_PACKETS = 8;
    const int GEN60_SLEEP = 4000;

    const int GEN40_PACKETS = 2;
    const int GEN40_SLEEP = 2000;

};

const int CAN_TEST_PACKET = 0;

#endif // MAINPROCESS_H
