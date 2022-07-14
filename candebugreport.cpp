#include "candebugreport.h"
#include "canmanager.h"

CANDebugReport * CANDebugReport::instance = nullptr;
bool CANDebugReport::doSendKeyReport = false;
bool CANDebugReport::doSendAlertsReport = false;

bool CANDebugReport::keyDown = false;
bool CANDebugReport::keyReturn = false;
bool CANDebugReport::keyUp = false;


CANDebugReport::CANDebugReport(QObject *parent) : QObject(parent)
{
  itsCanManager = nullptr;
}

void CANDebugReport::setSendKeyReport(bool doSend)
{
    doSendKeyReport = doSend;
}

void CANDebugReport::setSendAlertsReport(bool doSend)
{
    doSendAlertsReport = doSend;
}

CANDebugReport * CANDebugReport::getInstance(QObject *parent)
{
    if(nullptr == instance)
    {
        instance = new CANDebugReport(parent);
    }
    return instance;
}

void CANDebugReport::setCanManager(CanManager *aCanManager)
{
    itsCanManager = aCanManager;
}

void CANDebugReport::sendBrightness(quint32 illuminance_measure_mV, qint32 currentMenuLevel, qint32 currentOutput)
{
    struct can_frame debugFrame;

    memset(&debugFrame,  0 , sizeof(struct can_frame));

    debugFrame.can_id = 0x7b0;
    debugFrame.can_dlc = 8;
    //Actual brightness
    debugFrame.data[0] =  (quint8)(illuminance_measure_mV & 0xff);
    debugFrame.data[1] =  (quint8)((illuminance_measure_mV & 0x1f00) >> 010);
    //Menu Level selected:
    debugFrame.data[1] = debugFrame.data[1] | (quint8)((currentMenuLevel & 0x7) << 5);
    //Output brightness
    debugFrame.data[2] = (quint8)(currentOutput & 0x3f);
    debugFrame.data[2] = debugFrame.data[2] | 0x80; //brighness debug reported indicator
    if(nullptr != itsCanManager)
    {
        itsCanManager->write_frame(&debugFrame);
    }
}

void CANDebugReport::sendAlerts(bool PDZFstate, bool PDZRstate, bool PCWFstate, bool PCWRstate)
{
    if (doSendAlertsReport)
    {
        qDebug("Alerts report sent");

        struct can_frame debugFrame;

        memset(&debugFrame,  0 , sizeof(struct can_frame));

        debugFrame.data[4] = (quint8)0x1;

        if(PDZFstate) {debugFrame.data[4] |= 0x2;}
        if(PDZRstate) {debugFrame.data[4] |= 0x4;}
        if(PCWFstate) {debugFrame.data[4] |= 0x8;}
        if(PCWRstate) {debugFrame.data[4] |= 0x10;}

        debugFrame.can_id = 0x7b0;
        debugFrame.can_dlc = 8;

        if(nullptr != itsCanManager)
        {
            itsCanManager->write_frame(&debugFrame);
        }

    }


}

void CANDebugReport::sendButtonsReport(void)
{
    if (doSendKeyReport)
    {

        qDebug("Key report sent");

        struct can_frame debugFrame;

        memset(&debugFrame,  0 , sizeof(struct can_frame));

        debugFrame.data[3] = (quint8)true << 0
                                             | ((quint8)keyDown) << 1
                                             | ((quint8)keyReturn) << 2
                                             | ((quint8)keyUp) << 3
                                             ;

        debugFrame.can_id = 0x7b0;
        debugFrame.can_dlc = 8;

        if(nullptr != itsCanManager)
        {
            itsCanManager->write_frame(&debugFrame);
        }
    }
}



void CANDebugReport::sendButtonPressed(qint32 qtKey)
{

    switch(qtKey)
    {
    case Qt::Key_Down:

        keyDown =  true;

        break;

    case Qt::Key_Return:
        keyReturn = true;

        break;

    case Qt::Key_Up:

        keyUp = true;

        break;

    default:

        qDebug("Unsupported key to report");

        break;
    }


   sendButtonsReport();

}


void CANDebugReport::sendButtonReleased(qint32 qtKey)
{
    switch(qtKey)
    {
    case Qt::Key_Down:

        keyDown =  false;

        break;

    case Qt::Key_Return:
        keyReturn = false;

        break;

    case Qt::Key_Up:

        keyUp = false;

        break;

    default:

        qDebug("Unsupported key to report");

        break;
    }

    sendButtonsReport();


}

