#include "mainprocessupdate.h"
#include "updatecommon/caninterface.h"
#include "updatecommon/crc32.h"
#include "updatecommon/updatecanprotocol.h"
#include "updateengine/updatecanengine.h"
#include "updatecommon/version.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <cstring>

MainProcess::MainProcess()
{
    m_canInterface = new CANInterface(CANProtocol::UpdateCANPacketID, 1);
}

int MainProcess::LaunchEverything(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    CANUpdateEngine* updateEngine = new CANUpdateEngine(m_canInterface);
    m_canInterface->SetFrameProcessor((CANReceptor*)updateEngine);
    updateEngine->Launch();

    LOG("*************************************************\n");
    LOG("CAN Update Version: %d.%d.%d\n", GET_VERSION_MAJOR(SW_VERSION), GET_VERSION_MINOR(SW_VERSION), GET_VERSION_BUILD(SW_VERSION));
    LOG("*************************************************\n");


    m_canInterface->SleepWhileActive();

    return 0;
}



