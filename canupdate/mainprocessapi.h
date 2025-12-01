#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include "updatecommon/caninterface.h"

class MainProcess
{
public:

    MainProcess();

    int LaunchEverything(int argc, char *argv[]);

    CANInterface * m_canInterface;

    uint32_t m_counter;

};


#endif // MAINPROCESS_H
