#include <QThread>
#include <QMutex>

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QFile>
#include <iostream>
#include <chrono>
#include <thread>


#include "mainprocess.h"
#include "canmanager.h"
#include "ialertdisplay.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "rootedtreenode.h"

MainProcess* MainProcess::instance = nullptr;


MainProcess* MainProcess::getInstance(QQmlApplicationEngine *  engine)
{
    if (instance == 0)
      {
          instance = new MainProcess(engine);
      }

      return instance;
}


MainProcess::MainProcess(QQmlApplicationEngine *  engine)//(QObject *parent) : QObject(parent)
{
  //  mw = new MainWindow();
    QQmlComponent component(engine, "qrc:/main.qml");
    componentObject = component.create();

    flag_tree_changed = false;

    //Init QtQuick Objects:

    // //////////////////////////////


    canmgr = new CanManager(this);

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



    // generate map for alertTypes<->Objects
    EntityType::generateTypes();

// build panels trees
    mainPanelTree = new RootedTree(rootQobjectMainPannel);
    tsrPanelTree = new RootedTree(rootQobjectTsrPannel);
    statusPanelTree = new RootedTree(rootQobjectStatusPannel);
    smartADASPanelTree = new RootedTree(rootQobjectSADASPannel);
#if 0
    QmlTreeParser* qmlTreeParser = new QmlTreeParser();

    qmlTreeParser->constructTree(rootQobjectMainPannel, mainPanelTree);
#endif

    //connect(canmgr, &CanManager::resultReady, this, &MainProcess::handleResults);
    //connect(canmgr, &CanManager::finished, canmgr, &QObject::deleteLater);
}


void MainProcess::run()
{
    while(1)
    {
        if (flag_tree_changed)
        {
            mutex.lock();
            updateDisplay();
            flag_tree_changed = false;
            mutex.unlock();
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }
}




int MainProcess::exec()
{
    QObject * appWindow = MainProcess::componentObject; //->findChild<QObject*>("AppWindow");

    QObject::connect(appWindow, SIGNAL(itemSelfDeactivated(int, QString)),
                      this, SLOT(forceItemDeactivation(int, QString)));

    canmgr->start();

    this->start();

    return 0;
}


//TODO extract to different thread:
void MainProcess::updateDisplay(void)
{
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


    flag_tree_changed = false;
}

void MainProcess::activate(AlertTypes::EnAlert alert, quint8 value)
{

    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }
#if 1
    printf("function:%s alert: %d\n", __func__, alert);
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
            nodeCGRT->setCanEntityArg(value);
            nodeCGRT->activate();
            flag_tree_changed = true;
        }
    }

    return;
}

void MainProcess::deactivate(AlertTypes::EnAlert alert)
{
    if (AlertTypes::ALERT_NONE == alert)
    {
        //TODO single return point
        return;
    }

#if 1
    printf("function:%s alert: %d\n", __func__, alert);
#endif

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

void MainProcess::forceItemDeactivation(int _alertType, QString _objName) {

    std::cout << "Called the C++ slot with message:" << _alertType << ":" <<_objName.toLocal8Bit().constData() << std::endl;

    RootedTreeNode* nodeCGRT = nullptr;

    AlertTypes::EnAlert alertType = (AlertTypes::EnAlert)_alertType;

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


