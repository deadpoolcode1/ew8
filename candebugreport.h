#ifndef CANDEBUGREPORT_H
#define CANDEBUGREPORT_H

#include <QObject>
#include "canmanager.h"

class CanManager;

class CANDebugReport : public QObject
{
    Q_OBJECT
public:


    static CANDebugReport * getInstance(QObject *parent = nullptr);

    static void setSendKeyReport(bool doSend);

    static void setSendAlertsReport(bool doSend);

    void setCanManager(CanManager * aCanManager);

signals:


public slots:

    void sendBrightness(uint32_t illuminance_measure_mV, int32_t currentMenuLevel, int32_t currentOutput);

    void sendButtonPressed(int32_t qtKey);
    void sendButtonReleased(int32_t qtKey);

    void sendAlerts(bool PDZFstate, bool PDZRstate, bool PCWFstate, bool PCWRstate);


private:
     explicit CANDebugReport(QObject *parent = nullptr);

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
