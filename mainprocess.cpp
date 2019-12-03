#include <QThread>
#include <QMutex>
#include <QTimer>

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


MainProcess::MainProcess(QObject *aComponentObject, QThread * parent) : QThread(parent)
{

    componentObject = aComponentObject;

    flag_tree_changed = false;

    //Init QtQuick Objects:

    // //////////////////////////////


    canmgr = new CanManager(this);
#if 1
    QObject * rootQobjectGeneralPannel = MainProcess::componentObject->findChild<QObject*>("general_panel_root");
    if (!rootQobjectGeneralPannel)
    {
        // TBD display general error and go
    }
#else
    QObject * rootQobjectMainPannel = MainProcess::componentObject->findChild<QObject*>("main_panel_root");
    if (!rootQobjectMainPannel)
    {
        // TBD display general error and go
    }


    QObject * rootQobjectTsrPannel = MainProcess::componentObject->findChild<QObject*>("left_panel_root");
    if (!rootQobjectTsrPannel)
    {
        // TBD display general error and go
    }

    QObject * rootQobjectStatusPannel = MainProcess::componentObject->findChild<QObject*>("status_panel_root");
    if (!rootQobjectStatusPannel)
    {
        // TBD display general error and go
    }

    QObject * rootQobjectSADASPannel = MainProcess::componentObject->findChild<QObject*>("right_panel_root");
    if (!rootQobjectSADASPannel)
    {
        // TBD display general error and go
    }
#endif



    // generate map for alertTypes<->Objects
    EntityType::generateTypes();

// build panels trees
#if 1
    generalPanelTree = new RootedTree(rootQobjectGeneralPannel);
#else
    mainPanelTree = new RootedTree(rootQobjectMainPannel);
    tsrPanelTree = new RootedTree(rootQobjectTsrPannel);
    statusPanelTree = new RootedTree(rootQobjectStatusPannel);
    smartADASPanelTree = new RootedTree(rootQobjectSADASPannel);
#endif
    connect(this,SIGNAL(started()),SLOT(process()));

}

void MainProcess::process()
{
    if (flag_tree_changed)
    {
        mutex.lock();
        updateDisplay();
        flag_tree_changed = false;
        mutex.unlock();
    }
    QTimer::singleShot(10,this,SLOT(process()));
}

int MainProcess::launchEverything()
{
    QObject * appWindow = MainProcess::componentObject; //->findChild<QObject*>("AppWindow");

    QObject::connect(appWindow, SIGNAL(itemSelfDeactivated(QVariant, QString)),
                      this, SLOT(forceItemDeactivation(QVariant, QString)));

    canmgr->start();

    this->start();

    return 0;
}


//TODO extract to different thread:
void MainProcess::updateDisplay(void)
{
#if 1
    if (!generalPanelTree)
    {
        return;
    }

    generalPanelTree->updateVisibility();
#else
    if (!mainPanelTree)
    {
        return;
    }

    mainPanelTree->updateVisibility();

    if (!tsrPanelTree)
    {
        return;
    }

    tsrPanelTree->updateVisibility();

    if (!statusPanelTree)
    {
        return;
    }
    statusPanelTree->updateVisibility();

    if (!smartADASPanelTree)
    {
        return;
    }
    smartADASPanelTree->updateVisibility();
#endif

    flag_tree_changed = false;
}

void MainProcess::activate(DISPLAY_ITEM_ID alert, quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit)
{
     activate(alert, false, "", valueInt, valueFrac, unit);
}

void MainProcess::activate(DISPLAY_ITEM_ID alert, QString arg)
{
    activate(alert, true, arg, 0, 0, viu_None);
}


void MainProcess::activate(qint32 alert, bool isStrArg, QString strArg, quint8 valueInt, quint8 valueFrac, visual_item_unit_t unit)
{

    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }
#if 1
    qDebug("function:%s alert: %d\n", __func__, alert);
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
        }
    }

    return;
}

void MainProcess::deactivate(DISPLAY_ITEM_ID alert)
{
    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }

    qDebug("function:%s alert: %d\n", __func__, alert);

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
        }
    }
    return;

}

void MainProcess::forceItemDeactivation(QVariant _alertType, QString _objName) {


    RootedTreeNode* nodeCGRT = nullptr;

    bool isInt;

    DISPLAY_ITEM_ID alertType = (DISPLAY_ITEM_ID)_alertType.toInt(&isInt);

    if(!isInt)
    {
        alertType = GraphicItemsEnumMap::getId(_alertType.toString());
    }

    qDebug("Called the C++ slot with message: %d:%s" , alertType  ,qPrintable(_objName));


    EntityType::t_TreeNodesInterval itRange = EntityType::findByEntityType(alertType);



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
            if(nodeCGRT->getQmlItem() != nullptr && nodeCGRT->getQmlItem()->objectName() != nullptr
                    && nodeCGRT->getQmlItem()->objectName() == _objName)
            nodeCGRT->deactivate();
            //TODO only when a semaphore is changed
            flag_tree_changed = true;
        }
    }

    //WARNING: check if a mutex is necessary TBD!
    updateDisplay();

    return;


}


