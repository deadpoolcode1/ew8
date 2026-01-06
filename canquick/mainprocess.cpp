#include <QThread>
#include <QMutex>
#include <QTimer>
#include "core/core.h"
#include <QDateTime>

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QFile>

#include "mainprocess.h"
#include "canmanager.h"
#include "ialertdisplay.h"
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

    isDataComplete = false;

    flag_tree_changed = false;

    theBrightnessControl = nullptr;

    //Init QtQuick Objects:

    // //////////////////////////////

    coreDebug() << "CanManger init begin, time:" << bootUpTimer.elapsed();

    canmgr = new CanManager(this);

     coreDebug() << "CanManger init complete, time:" << bootUpTimer.elapsed();

    QObject * rootQobjectGeneralPannel = MainProcess::componentObject->findChild<QObject*>("general_panel_root");
    if (!rootQobjectGeneralPannel)
    {
        // TBD display general error and go
    }




    // generate map for alertTypes<->Objects
    EntityType::generateTypes();

// build panels trees
    generalPanelTree = new RootedTree(rootQobjectGeneralPannel, & flag_tree_changed, this);


    itsThread = new QThread(this);

    updateDisplayTimeWindow = new QTimer();

    updateDisplayTimeWindow->setInterval(30);

    updateDisplayTimeWindow->setSingleShot(true);

    this->moveToThread(itsThread);

    updateDisplayTimeWindow->moveToThread(itsThread);

    connect(itsThread,SIGNAL(started()),this,SLOT(process()));

    connect (this,SIGNAL(startUpdateDisplayWindow()), updateDisplayTimeWindow, SLOT(start()));

    connect(updateDisplayTimeWindow,SIGNAL(timeout()),this,SLOT(process()));

     coreDebug() << "MainManager init complete, time:" << bootUpTimer.elapsed();
}

void MainProcess::process()
{

    if (isDataComplete && flag_tree_changed)
    {
        if(Q_LIKELY(!updateDisplayTimeWindow->isActive()))
        {
            flag_tree_changed = false;
            isDataComplete = false;
            emit startUpdateDisplayWindow();
            mutex.lock();
            coreDebug()<< "updateStart:" << QDateTime::currentMSecsSinceEpoch();
            updateDisplay();
            coreDebug()<< "updateEnd:" << QDateTime::currentMSecsSinceEpoch();
            mutex.unlock();

        }
    }
#if 0
    //TODO Set as update time window
    QTimer::singleShot(30,this,SLOT(process()));
#endif
}

void MainProcess::message(const std::string& stringMessage)
{
   emit messageDisplayWindow(QVariant(QString::fromStdString(stringMessage)));
}


void MainProcess::setBrightnessControl(BrightnessControl *aBrightnessControl)
{
    theBrightnessControl =  aBrightnessControl;
    theBrightnessControl->setItsDisplay(this);

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
        CANDebugReport::getInstance(canmgr)->setCanManager(canmgr);
        // BrightnessControl::sendBrightness is a core::Signal, connect it to CANDebugReport's slot
        theBrightnessControl->sendBrightness.connect([](uint32_t a, int32_t b, int32_t c) {
            CANDebugReport::getInstance()->sendBrightness(a, b, c);
        });

        QObject::connect(appWindow, SIGNAL(keyPressedReportSend(int32_t)),
                          CANDebugReport::getInstance(), SLOT(sendButtonPressed(int32_t)));
        QObject::connect(appWindow, SIGNAL(keyReleasedReportSend(int32_t)),
                          CANDebugReport::getInstance(), SLOT(sendButtonReleased(int32_t)));

        QObject::connect(appWindow, SIGNAL(alertsReportSend(bool,bool,bool,bool)),
                          CANDebugReport::getInstance(), SLOT(sendAlerts(bool,bool,bool,bool)));
#if 0
        if (-1 != appWindow->metaObject()->indexOfSlot(QMetaObject::normalizedSignature("alertsReportSend(bool, bool, bool, bool)")))
        {
            coreDebug()<<"alertsReportSend(bool, bool, bool, bool) connected";
        }
        else
        {
             coreDebug()<<"alertsReportSend(bool, bool, bool, bool) is not present.";
        }
#endif
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
        flag_tree_changed = false;
        generalPanelTree->updateVisibility();

    }
}

void MainProcess::activate(DISPLAY_ITEM_ID alert, uint8_t valueInt, uint8_t valueFrac, uint8_t unit)
{
     activateInternal(alert, false, "", valueInt, valueFrac, unit);
}

void MainProcess::activate(DISPLAY_ITEM_ID alert, const std::string& stringArg)
{
    activateInternal(alert, true, stringArg, 0, 0, 0);
}


void MainProcess::activateInternal(DISPLAY_ITEM_ID alert, bool isStrArg, const String& strArg, uint8_t valueInt, uint8_t valueFrac, uint8_t unit)
{

    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }
#if 1
    coreDebug() << "function:" << __func__ << "alert:" << alert;
    coreDebug() << " activated at:" << QDateTime::currentMSecsSinceEpoch();

#endif

    RootedTreeNode* nodeCGRT = nullptr;

    EntityType::t_TreeNodesInterval itRange = EntityType::findByEntityType(alert);


    for (EntityType::t_TreeNodesTypeMap::iterator it = itRange.first; it != itRange.second; it++)
    {

        nodeCGRT = it->second;

        if (nodeCGRT == NULL)
        {
            //TODO add exception
        }
        else if (nodeCGRT->getActivSem() > 0)
        {
            //skip:  activated - no need for re-activation
        }
        else
        {
            if(isStrArg)
            {
                nodeCGRT->setCanEntityArg(strArg);
            }
            else
            {
                nodeCGRT->setCanEntityArgs(valueInt, valueFrac, unit);
            }
            nodeCGRT->activate();
            flag_tree_changed = true;
#if 0
            process();
#endif
        }
    }

    return;
}

void MainProcess::forceUpdate(void)
{
    isDataComplete = true;
    if(flag_tree_changed)
    {
        process();
    }
}

void MainProcess::deactivate(DISPLAY_ITEM_ID alert)
{
    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }

    coreDebug() << "function:" << __func__ << "alert:" << alert;
    coreDebug() << "deactivated at:" << QDateTime::currentMSecsSinceEpoch();

    RootedTreeNode* nodeCGRT = nullptr;

    EntityType::t_TreeNodesInterval itRange = EntityType::findByEntityType(alert);



    for (EntityType::t_TreeNodesTypeMap::iterator it = itRange.first; it != itRange.second; it++)
    {

        nodeCGRT = it->second;

        if (nodeCGRT == nullptr)
        {
            //TODO add exception
        }

        if (!(nodeCGRT->getActivSem()))
        {
            //skip: deactivated - no need for deactivation
        }
        else
        {
            nodeCGRT->deactivate();
            //TODO only when a semaphore is changed
            flag_tree_changed = true;
#if 0
            process();
#endif
        }
    }

    return;

}


void MainProcess::volumeKeySent(int32_t qtKey)
{

  coreDebug() << "volumeKeySent";
  switch(qtKey)
  {
  case Qt::Key_Return:

      canmgr->sendVolumeGet();
      break;

  case Qt::Key_VolumeMute:
      canmgr->sendVolumeMute();

      break;

  case Qt::Key_VolumeDown:
      canmgr->sendVolumeDown();
      break;

  case Qt::Key_VolumeUp:
      canmgr->sendVolumeUp();
      break;

  default:

      coreDebug() << "Unsupported Volume key";

      break;
  }
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

