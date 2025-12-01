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

    void sendBrightness(quint32 illuminance_measure_mV, qint32 currentMenuLevel, qint32 currentOutput);

    void sendButtonPressed(qint32 qtKey);
    void sendButtonReleased(qint32 qtKey);

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
