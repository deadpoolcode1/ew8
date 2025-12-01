#include "mainprocessload.h"
#include "../updatecommon/caninterface.h"
#include "../updatecommon/crc32.h"
#include "../updatecommon/updatecanprotocol.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cstring>


MainProcess::MainProcess()
{
    m_canInterface = new CANInterface(CAN_TEST_PACKET, 1);

    m_counter = 0;
}

void MainProcess::GenTraffic(int _count, int _sleep)
{
     usleep(_sleep);

     for(int iii=0; iii <= _count; iii++)
     {
         // gen packet
         can_frame frame;
         frame.can_id = CAN_TEST_PACKET;
         frame.can_dlc = 8;
         *((uint32_t*)(&(frame.data[4]))) = m_counter;
         *((uint32_t*)(&(frame.data[0]))) = m_counter++;

         frame.data[7] = crc8buf(&(frame.data[0]), 7);

         m_canInterface->WriteFrame(&frame);
     }
}

int MainProcess::LaunchEverything(int argc, char *argv[])
{
    PacketTester* packetTester = new PacketTester();

    m_canInterface->SetFrameProcessor((CANReceptor*) packetTester);

    bool Gen90Flag = false;
    bool Gen70Flag = false;
    bool Gen60Flag = false;
    bool Gen50Flag = false;

    printf("Running test");

    if (argc>1)
    {
        Gen90Flag = (0==strcasecmp(argv[1], "-gen90"));
        Gen70Flag = (0==strcasecmp(argv[1], "-gen70"));
        Gen60Flag = (0==strcasecmp(argv[1], "-gen60"));
        Gen50Flag = (0==strcasecmp(argv[1], "-gen50"));
    }

    LOG("Running load test\n");

    while(1)
    {
        if (Gen90Flag) GenTraffic(GEN90_PACKETS, GEN90_SLEEP);
        if (Gen70Flag) GenTraffic(GEN70_PACKETS, GEN70_SLEEP);
        if (Gen60Flag) GenTraffic(GEN60_PACKETS, GEN60_SLEEP);
        if (Gen50Flag) GenTraffic(GEN50_PACKETS, GEN50_SLEEP);
    }

    return 0;
}



