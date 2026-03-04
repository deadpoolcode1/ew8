#include "core/core.h"
#include "core/mutex.h"
#include "core/elapsed_timer.h"

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include "core/thread.h"
#include "core/timer.h"
#include "core/file_utils.h"

#include "mainprocess.h"
#include "canmanager.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "rootedtreenode.h"
#include "graphicitemsenummap.h"

class GraphicItemsEnumMap;

MainProcess* MainProcess::instance = nullptr;


#include "candebugreport.h"

class CANDebugReport;


MainProcess* MainProcess::getInstance(QObject * aComponentObject)
{
    if (instance == nullptr)
      {
          instance = new MainProcess(aComponentObject);
      }

      return instance;
}


MainProcess::MainProcess(QObject *aComponentObject, QObject * parent) : QObject(parent)
{

    componentObject = aComponentObject;

    theBrightnessControl = nullptr;

    //Init QtQuick Objects:

    // //////////////////////////////

    coreDebug() << "CanManger init begin, time:" << bootUpTimer.elapsed();

    alertController = new AlertController();

    canmgr = new CanManager(alertController);

     coreDebug() << "CanManger init complete, time:" << bootUpTimer.elapsed();

    QObject * rootQobjectGeneralPannel = MainProcess::componentObject->findChild<QObject*>("general_panel_root");
    if (!rootQobjectGeneralPannel)
    {
        // TBD display general error and go
    }




    // generate map for alertTypes<->Objects
    EntityType::generateTypes();

// build panels trees
    generalPanelTree = new RootedTree(rootQobjectGeneralPannel, [this]() {
        alertController->setTreeChanged();
        alertController->forceUpdate();
    });


    itsThread = new core::Thread();

    updateDisplayTimeWindow = new core::Timer();

    updateDisplayTimeWindow->setInterval(30);

    updateDisplayTimeWindow->setSingleShot(true);

    itsThread->started.connect([this]() { process(); });

    updateDisplayTimeWindow->timeout.connect([this]() { process(); });

    alertController->setMessageCallback([this](const std::string& msg) {
        emit messageDisplayWindow(QVariant(String(msg).toQString()));
    });

    alertController->setProcessCallback([this]() { process(); });

     coreDebug() << "MainManager init complete, time:" << bootUpTimer.elapsed();
}

void MainProcess::process()
{

    if (alertController->needsDisplayUpdate())
    {
        if(!updateDisplayTimeWindow->isActive())
        {
            alertController->markUpdateComplete();
            updateDisplayTimeWindow->start();
            alertController->mutex.lock();
            coreDebug()<< "updateStart:" << core::ElapsedTimer::currentMSecsSinceEpoch();
            updateDisplay();
            coreDebug()<< "updateEnd:" << core::ElapsedTimer::currentMSecsSinceEpoch();
            alertController->mutex.unlock();

        }
    }
}


void MainProcess::setBrightnessControl(BrightnessControl *aBrightnessControl)
{
    theBrightnessControl =  aBrightnessControl;
    theBrightnessControl->setItsDisplay(alertController);

}

int MainProcess::launchEverything()
{
    QObject * appWindow = MainProcess::componentObject; //->findChild<QObject*>("AppWindow");


    QObject::connect(appWindow, SIGNAL(debugMessagesConnect(bool)),
                      this, SLOT(debugMessagesConnected(bool)));

    QObject::connect(appWindow, SIGNAL(volumeKeySend(int32_t)),
                      this, SLOT(volumeKeySent(int32_t)));

    QObject::connect(appWindow, SIGNAL(isaFullActivationRequest()),
                      this, SLOT(isaFullActivationRequestSend()));

    QObject::connect(appWindow, SIGNAL(isaPartialDeactivationRequest()),
                      this, SLOT(isaPartialDeactivationRequestSend()));


    QObject::connect(appWindow, SIGNAL(isaFullDeactivationRequest()),
                      this, SLOT(isaFullDeactivationRequestSend()));




    if(nullptr != theBrightnessControl)
    {
        // BrightnessControl doesn't inherit QObject, so use MainProcess as intermediary
        QObject::connect(appWindow, SIGNAL(brightnessChanged(int32_t)),
                         this, SLOT(forwardBrightnessChanged(int32_t)));
    }
    else
    {
        coreDebug() << "Please set brightness control!";
    }

    canmgr->launch();

    if(nullptr != theBrightnessControl)
    {
        CANDebugReport::getInstance()->setCanManager(canmgr);
        // BrightnessControl::sendBrightness is a core::Signal, connect it to CANDebugReport's slot
        theBrightnessControl->sendBrightness.connect([](uint32_t a, int32_t b, int32_t c) {
            CANDebugReport::getInstance()->sendBrightness(a, b, c);
        });

        QObject::connect(appWindow, SIGNAL(keyPressedReportSend(int32_t)),
                          this, SLOT(onKeyPressedReport(int32_t)));
        QObject::connect(appWindow, SIGNAL(keyReleasedReportSend(int32_t)),
                          this, SLOT(onKeyReleasedReport(int32_t)));

        QObject::connect(appWindow, SIGNAL(alertsReportSend(bool,bool,bool,bool)),
                          this, SLOT(onAlertsReport(bool,bool,bool,bool)));
    }


    itsThread->start();

    return 0;
}

void MainProcess::debugMessagesConnected(bool On)
{
  if (On)
  {
    QObject * appWindow = MainProcess::componentObject; //->findChild<QObject*>("AppWindow");
    QObject::connect(this, SIGNAL(messageDisplayWindow(QVariant)), appWindow, SLOT(debugMessage(QVariant)));
  }
  else
  {
    QObject::disconnect(this, SIGNAL(messageDisplayWindow(QVariant)), nullptr, nullptr);
  }
}


//TODO extract to different thread:
void MainProcess::updateDisplay(void)
{
    if (generalPanelTree)
    {
        generalPanelTree->updateVisibility();

    }
}


// Qt key codes for volume keys (received from QML frontend)
static const int32_t KEY_RETURN     = 0x01000004;
static const int32_t KEY_VOLUMEMUTE = 0x01000071;
static const int32_t KEY_VOLUMEDOWN = 0x01000070;
static const int32_t KEY_VOLUMEUP   = 0x01000072;

void MainProcess::volumeKeySent(int32_t qtKey)
{

  coreDebug() << "volumeKeySent";
  if      (qtKey == KEY_RETURN)     canmgr->sendVolumeGet();
  else if (qtKey == KEY_VOLUMEMUTE) canmgr->sendVolumeMute();
  else if (qtKey == KEY_VOLUMEDOWN) canmgr->sendVolumeDown();
  else if (qtKey == KEY_VOLUMEUP)   canmgr->sendVolumeUp();
  else coreDebug() << "Unsupported Volume key";
}

void MainProcess::isaFullActivationRequestSend()
{
  canmgr->sendISAFullActivate();
}



void MainProcess::isaPartialDeactivationRequestSend()
{
    canmgr->sendISAPartDeact();
}

void MainProcess::isaFullDeactivationRequestSend()
{
    canmgr->sendISAFullDeact();
}

void MainProcess::forwardBrightnessChanged(int32_t newLevel)
{
    if (theBrightnessControl != nullptr) {
        theBrightnessControl->brightnessLevelChanged(newLevel);
    }
}

void MainProcess::onKeyPressedReport(int32_t key)
{
    CANDebugReport::getInstance()->sendButtonPressed(key);
}

void MainProcess::onKeyReleasedReport(int32_t key)
{
    CANDebugReport::getInstance()->sendButtonReleased(key);
}

void MainProcess::onAlertsReport(bool a, bool b, bool c, bool d)
{
    CANDebugReport::getInstance()->sendAlerts(a, b, c, d);
}
