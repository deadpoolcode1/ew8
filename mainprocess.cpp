#include <QThread>
#include <QMutex>

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QFile>
#include <iostream>

#include "mainprocess.h"
#include "canmanager.h"
#include "ialertdisplay.h"
#include "alerttypes.h"
#include "entitytype.h"
#include "rootedtreenode.h"



MainProcess::MainProcess(QQmlApplicationEngine *  engine)//(QObject *parent) : QObject(parent)
{
  //  mw = new MainWindow();

    QQmlComponent component(engine, "qrc:/main.qml");
    componentObject = component.create();

    flag_updated = false;

    //Init QtQuick Objects:

    // //////////////////////////////


    canmgr = new CanManager(this);

    QObject * rootQobjectMainPannel = componentObject->findChild<QObject*>("main_panel_root");
    if (!rootQobjectMainPannel)
    {
        // TBD display general error and go
    }

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
        if (flag_updated)
        {
            mutex.lock();
            updateDisplay();
            mutex.unlock();
        }
        sleep(10);
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

}


#if 0
void MainProcess::pdz_display(bool on)
{

    if(on && !pdz_flag)
    {
       pdz_flag = true;
       flag_updated = true;
    }
    else if(!on && pdz_flag)
    {
        pdz_flag = false;
        flag_updated = true;
    }

}

void MainProcess::pcw_display(bool on)
{

    if(on && !pcw_flag)
    {
        pcw_flag = true;
        flag_updated = true;
    }
    else if(!on && pcw_flag)
    {
        pcw_flag =  false;
        flag_updated = true;
    }

}
#endif
