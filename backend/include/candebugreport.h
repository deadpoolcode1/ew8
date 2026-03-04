#ifndef CANDEBUGREPORT_H
#define CANDEBUGREPORT_H

#include "canmanager.h"

class CanManager;

class CANDebugReport
{
public:

    static CANDebugReport * getInstance();

    static void setSendKeyReport(bool doSend);

    static void setSendAlertsReport(bool doSend);

    void setCanManager(CanManager * aCanManager);

    void sendBrightness(uint32_t illuminance_measure_mV, int32_t currentMenuLevel, int32_t currentOutput);

    void sendButtonPressed(int32_t key);
    void sendButtonReleased(int32_t key);

    void sendAlerts(bool PDZFstate, bool PDZRstate, bool PCWFstate, bool PCWRstate);

private:
     explicit CANDebugReport();

    void sendButtonsReport(void);

     CanManager * itsCanManager;
     static CANDebugReport * instance;
     static bool doSendKeyReport;
     static bool doSendAlertsReport;

     static bool keyDown;
     static bool keyReturn;
     static bool keyUp;
};

#endif // CANDEBUGREPORT_H
