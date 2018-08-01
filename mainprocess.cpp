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

    // generate map for alertTypes<->Objects
    EntityType::generateTypes();

// build panels trees
    mainPanelTree = new RootedTree(rootQobjectMainPannel);
//    tsrPanelTree = new RootedTree(rootQobjectTsrPannel);
//    statusPanelTree = new RootedTree(rootQobjectStatusPannel);
 //   smartADASPanelTree = new RootedTree(rootQobjectSADASPannel);
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

//    QMetaObject::invokeMethod(componentObject,"setAlert",Q_ARG(QVariant, msg), Q_ARG(QVariant, is_active));

    flag_tree_changed = false;
}


void MainProcess::handleResults(const QString &)
{



}

void MainProcess::activate(AlertTypes::EnAlert alert)
{
    mutex.tryLock();

    RootedTreeNode* nodeCGRT = EntityType::findByEntityType(alert);
    if (nodeCGRT == NULL)
    {
        // add exception
    }
    if (nodeCGRT->getActivSem() > 0)
    {
        return; // activated - no need for re-activation
    }
    nodeCGRT->activate();

    flag_tree_changed = true;

    return;
}

void MainProcess::deactivate(AlertTypes::EnAlert alert)
{
    RootedTreeNode* nodeCGRT = EntityType::findByEntityType(alert);
    if (nodeCGRT == NULL)
    {
        // add exception
    }

    if (!(nodeCGRT->getActivSem()))
    {
        return; // deactivated - no need for deactivation
    }
    nodeCGRT->deactivate();

    //TODO only when a semaphore is changed
    flag_tree_changed = true;

    return;

}


