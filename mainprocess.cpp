#include "mainprocess.h"
#include "canmanager.h"
//#include "mainwindow.h"
#include "ialertdisplay.h"

#include <QThread>

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QFile>
#include <iostream>

MainProcess::MainProcess(QQmlApplicationEngine *  engine)//(QObject *parent) : QObject(parent)
{
  //  mw = new MainWindow();

    QQmlComponent component(engine, "qrc:/main.qml");
    componentObject = component.create();

    objImage = componentObject->findChild<QObject *>("objAlert");

    pdz_flag = true;
    pcw_flag = false;

    //Init QtQuick Objects:

    // //////////////////////////////


    canmgr = new CanManager(this);

    //connect(canmgr, &CanManager::resultReady, this, &MainProcess::handleResults);
    //connect(canmgr, &CanManager::finished, canmgr, &QObject::deleteLater);
}

int MainProcess::exec()
{
    canmgr->start();
    return 0;
}


//TODO extract to different thread:
void MainProcess::updateDisplay(void)
{

        //Display Visibility Update:

        if(!(pcw_flag||pdz_flag))
        {

          objImage->setProperty("visible",QString("false"));
        }
        else
        {
           objImage->setProperty("visible",QString("true"));
        }


        //QThread.yieldCurrentThread();
        //////////////////////
}


void MainProcess::handleResults(const QString &)
{



}

void MainProcess::pdz_display(bool on)
{

    if(on)
    {
       // mw->move(40,40);

        if(objImage)
        {
           objImage->setProperty("source",QStringLiteral("qrc:/resources/sp_yellow_h.png"));
        }
        pdz_flag = true;
    }
    else
    {
        pdz_flag = false;
    }
}

void MainProcess::pcw_display(bool on)
{

    if(on)
    {
        if(objImage)
        {
           objImage->setProperty("source",QStringLiteral("qrc:/resources/sp_red_h.png"));
        };
        pcw_flag = true;

    }
    else
    {
       pcw_flag =  false;
    }
}
