#include <QThread>
#include <QMutex>
#include <QTimer>
#include <QDebug>
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

    //Init QtQuick Objects:

    // //////////////////////////////

    qDebug() << "CanManger init begin, time:" << bootUpTimer.elapsed();

    canmgr = new CanManager(this);

     qDebug() << "CanManger init complete, time:" << bootUpTimer.elapsed();

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

     qDebug() << "MainManager init complete, time:" << bootUpTimer.elapsed();
}

void MainProcess::process()
{

    if (isDataComplete && flag_tree_changed)
    {
        if(Q_LIKELY(!updateDisplayTimeWindow->isActive()))
        {
            flag_tree_changed = false;
            isDataComplete = false;
            startUpdateDisplayWindow();
            mutex.lock();
            qDebug()<< "updateStart:" << QDateTime::currentMSecsSinceEpoch();
            updateDisplay();
            qDebug()<< "updateEnd:" << QDateTime::currentMSecsSinceEpoch();
            mutex.unlock();

        }
    }
#if 0
    //TODO Set as update time window
    QTimer::singleShot(30,this,SLOT(process()));
#endif
}

int MainProcess::launchEverything()
{
    QObject * appWindow = MainProcess::componentObject; //->findChild<QObject*>("AppWindow");

#if 0
    QObject::connect(appWindow, SIGNAL(itemSelfDeactivated(QVariant, QString)),
                      this, SLOT(forceItemDeactivation(QVariant, QString)));
#endif

    QObject::connect(appWindow, SIGNAL(volumeKeySend(qint32)),
                      this, SLOT(volumeKeySent(qint32)));


    canmgr->launch();

    itsThread->start();

    return 0;
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

void MainProcess::activate(DISPLAY_ITEM_ID alert, quint8 valueInt, quint8 valueFrac, quint8 unit)
{
     activate(alert, false, "", valueInt, valueFrac, unit);
}

void MainProcess::activate(DISPLAY_ITEM_ID alert, QString arg)
{
    activate(alert, true, arg, 0, 0, 0);
}


void MainProcess::activate(qint32 alert, bool isStrArg, QString strArg, quint8 valueInt, quint8 valueFrac, quint8 unit)
{

    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }
#if 1
    qDebug("function:%s alert: %d\n", __func__, alert);
    qDebug()<< " activated at:" << QDateTime::currentMSecsSinceEpoch();

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

    qDebug("function:%s alert: %d\n", __func__, alert);
    qDebug()<< "deactivated at:" << QDateTime::currentMSecsSinceEpoch();

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

void MainProcess::volumeKeySent(qint32 qtKey)
{

  qDebug("volumeKeySent");
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

      qDebug("Unsupported Volume key");

      break;
  }
}



