#include "mainprocess.h"
#include "canmanager.h"
//#include "mainwindow.h"
#include "ialertdisplay.h"

#include <QThread>
#include <QMutex>

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QFile>
#include <iostream>

MainProcess::MainProcess(QQmlApplicationEngine *  engine)//(QObject *parent) : QObject(parent)
{
  //  mw = new MainWindow();

    QQmlComponent component(engine, "qrc:/main.qml");
    componentObject = component.create();

    pdz_flag = true;
    pcw_flag = false;
    flag_updated = false;

    //Init QtQuick Objects:

    // //////////////////////////////


    canmgr = new CanManager(this);

    //connect(canmgr, &CanManager::resultReady, this, &MainProcess::handleResults);
    //connect(canmgr, &CanManager::finished, canmgr, &QObject::deleteLater);
}


void MainProcess::run()
{
    while(1)
    {

      updateDisplay();

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

    QVariant msg;

    //Display Visibility Update:

if(flag_updated)
{

    flag_updated = false;

    mutex.lock();

    if(pcw_flag)
    {
        msg = QVariant("pcw");

    }
    else if(pdz_flag)

    {
        msg= QVariant("pdz");

    }
    else
    {
        msg= QVariant("noalerts");
    }

    mutex.unlock();


    QMetaObject::invokeMethod(componentObject,"setAlert",Q_ARG(QVariant, msg));





}

}


void MainProcess::handleResults(const QString &)
{



}

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
